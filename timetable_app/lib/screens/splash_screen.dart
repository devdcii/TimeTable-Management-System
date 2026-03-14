// lib/screens/splash_screen.dart

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'welcome_screen.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => authProvider.isLoggedIn
            ? const HomeScreen()
            : const WelcomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App Icon - Solid Blue Design
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF007AFF),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007AFF).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: const Icon(
                CupertinoIcons.time,
                size: 70,
                color: CupertinoColors.white,
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              'CpE TimeTable',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D3436),
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Create and manage your personal',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Text(
              'schedule with ease',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: CupertinoColors.systemGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 50),
            const CupertinoActivityIndicator(
              radius: 15,
              animating: true,
            ),
          ],
        ),
      ),
    );
  }
}