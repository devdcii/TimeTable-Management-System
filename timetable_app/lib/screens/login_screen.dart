import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'signup_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill in all fields');
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final result = await authProvider.login(email, password);

    if (!mounted) return;

    if (result['success']) {
      Navigator.of(context).pushReplacement(
        CupertinoPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      _showErrorDialog(result['message']);
    }
  }

  void _showErrorDialog(String message) {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: CupertinoColors.white,
        border: null,
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          child: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              children: [
                const SizedBox(height: 40),
                // App Icon - Blue Design
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFF007AFF),
                    borderRadius: BorderRadius.circular(25),
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
                    size: 50,
                    color: CupertinoColors.white,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'Welcome Back',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2D3436),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Log in to continue to your account',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: CupertinoColors.systemGrey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 50),
                // Email Field
                CupertinoTextField(
                  controller: _emailController,
                  placeholder: 'Email Address',
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(
                      CupertinoIcons.mail,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                // Password Field with Eye Icon
                CupertinoTextField(
                  controller: _passwordController,
                  placeholder: 'Password',
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    border: Border.all(color: const Color(0xFFE9ECEF)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  obscureText: _obscurePassword,
                  prefix: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(
                      CupertinoIcons.lock,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                  suffix: CupertinoButton(
                    padding: const EdgeInsets.only(right: 8),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                    child: Icon(
                      _obscurePassword
                          ? CupertinoIcons.eye_slash
                          : CupertinoIcons.eye,
                      color: const Color(0xFF007AFF),
                    ),
                  ),
                ),
                const SizedBox(height: 44),
                // Login Button - 50% width
                Consumer<AuthProvider>(
                  builder: (context, auth, _) {
                    return Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 50,
                        child: CupertinoButton(
                          color: const Color(0xFF007AFF),
                          borderRadius: BorderRadius.circular(12),
                          padding: EdgeInsets.zero,
                          onPressed: auth.isLoading ? null : _handleLogin,
                          child: auth.isLoading
                              ? const CupertinoActivityIndicator(
                            color: CupertinoColors.white,
                          )
                              : const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: CupertinoColors.white,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.systemGrey,
                      ),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      minSize: 0,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF007AFF),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          CupertinoPageRoute(
                            builder: (context) => const SignUpScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}