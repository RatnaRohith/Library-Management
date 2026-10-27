import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:library_book_app/services/auth_service.dart';

void main() {
  late Directory tempDirectory;
  late File credentialsFile;
  late AuthService auth;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('booknest_auth_');
    credentialsFile = File('${tempDirectory.path}/credentials.json');
    auth = AuthService(credentialsFile: credentialsFile);
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  test('seeds demo account and accepts valid credentials', () async {
    expect(await auth.login('student@library.com', 'Library123'), isTrue);
    expect(await credentialsFile.exists(), isTrue);
  });

  test('rejects an incorrect password', () async {
    expect(await auth.login('student@library.com', 'wrongpass'), isFalse);
  });

  test('rejects an unknown email', () async {
    expect(await auth.login('unknown@example.com', 'Library123'), isFalse);
  });

  test('registers a user and retains credentials in JSON', () async {
    expect(await auth.register('reader@example.com', 'BookPass123'), isTrue);
    expect(await auth.login('reader@example.com', 'BookPass123'), isTrue);

    final savedJson = await credentialsFile.readAsString();
    expect(savedJson, contains('reader@example.com'));
    expect(savedJson, isNot(contains('BookPass123')));
  });

  test('does not register duplicate email addresses', () async {
    await auth.login('student@library.com', 'Library123');
    expect(await auth.register('STUDENT@library.com', 'AnotherPass1'), isFalse);
  });
}
