import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'providers/library_provider.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => LibraryProvider(),
      child: const LibraryBookApp(),
    ),
  );
}

class LibraryBookApp extends StatefulWidget {
  const LibraryBookApp({super.key});

  @override
  State<LibraryBookApp> createState() => _LibraryBookAppState();
}

class _LibraryBookAppState extends State<LibraryBookApp> {
  bool _loggedIn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BookNest Library',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        child: _loggedIn
            ? HomePage(
                key: const ValueKey('home'),
                onLogout: () => setState(() => _loggedIn = false),
              )
            : LoginPage(
                key: const ValueKey('login'),
                onLoginSuccess: () => setState(() => _loggedIn = true),
              ),
      ),
    );
  }
}
