// lib/screens/welcome_screen.dart

import 'package:flutter/cupertino.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
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
              // Welcome Text
              const Text(
                'Welcome To',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2D3436),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'CpE TimeTable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF007AFF),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Create and manage your personal schedule with ease',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: CupertinoColors.systemGrey,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              const Spacer(),
              // Get Started Button - 50% width
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 50,
                  child: CupertinoButton(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(12),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Get Started',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: CupertinoColors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minSize: 0,
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF007AFF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}