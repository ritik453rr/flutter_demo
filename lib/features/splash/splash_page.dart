import 'package:flutter/material.dart';
import '../../core/constants/app_theme.dart';
import '../../core/extension/sized_box_extension.dart';
import '../../core/storage/app_storage.dart';
import '../auth/login_page.dart';
import '../home/home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _initSplash();
  }

  Future<void> _initSplash() async {
    // Display splash for 2 seconds before navigating based on login status
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final isLoggedIn = AppStorage.getLoginStatus();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => isLoggedIn ? const HomePage() : const LoginPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bolt_rounded,
                size: 64,
                color: Colors.blue,
              ),
            ),
            24.h,
            const Text(
              'Flutter Demo',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            8.h,
            const Text(
              'Welcome to your application',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            48.h,
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
