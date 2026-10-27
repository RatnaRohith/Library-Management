import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';

/// Local JSON authentication for classroom demonstration.
/// Passwords are stored as SHA-256 hashes, not plain text. This is not a
/// replacement for a secure server-side authentication system.
class AuthService {
  AuthService({File? credentialsFile}) : _credentialsFile = credentialsFile;

  static const demoEmail = 'student@library.com';
  static const demoPassword = 'Library123';

  final File? _credentialsFile;

  Future<File> _getCredentialsFile() async {
    if (_credentialsFile != null) return _credentialsFile!;
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}${Platform.pathSeparator}credentials.json');
  }

  String _hashPassword(String password) =>
      sha256.convert(utf8.encode(password)).toString();

  Future<List<Map<String, dynamic>>> _readUsers(File file) async {
    if (!await file.exists()) {
      await file.parent.create(recursive: true);
      final initialUsers = [
        {
          'email': demoEmail,
          'passwordHash': _hashPassword(demoPassword),
        },
      ];
      await file.writeAsString(
        const JsonEncoder.withIndent('  ').convert({'users': initialUsers}),
      );
      return initialUsers;
    }

    final contents = await file.readAsString();
    if (contents.trim().isEmpty) return [];
    final decoded = jsonDecode(contents) as Map<String, dynamic>;
    final users = decoded['users'] as List<dynamic>? ?? [];
    return users.whereType<Map<String, dynamic>>().toList();
  }

  /// Returns true when the email and password match a saved local account.
  Future<bool> login(String email, String password) async {
    final file = await _getCredentialsFile();
    final users = await _readUsers(file);
    final normalizedEmail = email.trim().toLowerCase();
    final passwordHash = _hashPassword(password);

    return users.any((user) =>
        (user['email']?.toString().toLowerCase() == normalizedEmail) &&
        user['passwordHash'] == passwordHash);
  }

  /// Saves a new local account in credentials.json.
  /// Returns false if an account with that email already exists.
  Future<bool> register(String email, String password) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (normalizedEmail.isEmpty || password.length < 6) return false;

    final file = await _getCredentialsFile();
    final users = await _readUsers(file);
    if (users.any((user) =>
        user['email']?.toString().toLowerCase() == normalizedEmail)) {
      return false;
    }

    users.add({
      'email': normalizedEmail,
      'passwordHash': _hashPassword(password),
    });
    await file.writeAsString(
      const JsonEncoder.withIndent('  ').convert({'users': users}),
      flush: true,
    );
    return true;
  }
}
