import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/screens/auth/register.dart';
import 'package:iot/rootnavigator.dart';
import 'package:iot/utils/app_colors.dart';
import 'package:iot/services/auth_service.dart';
import 'package:quickalert/quickalert.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  // Demo credentials (for testing, will also work with Firebase)
  final String _demoEmail = 'demo@prohome.com';
  final String _demoPassword = 'demo123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Sign in with email and password
        final userData = await _authService.signInWithEmailAndPassword(
          _emailController.text.trim(),
          _passwordController.text,
        );

        if (mounted) {
          setState(() {
            _isLoading = false;
          });

          // Show success message
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            animType: QuickAlertAnimType.slideInUp,
            borderRadius: 25,
            title: "Login Successful",
            text: "Welcome back!",
            textColor: Colors.white,
            backgroundColor: Colors.grey.shade900,
            showConfirmBtn: true,
            confirmBtnText: "Continue",
            onConfirmBtnTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RootNavigator()),
              );
            },
          );
        }
      } catch (e) {
          setState(() {
            _isLoading = false;
          });

          if (mounted) {
            QuickAlert.show(
              context: context,
              type: QuickAlertType.error,
              animType: QuickAlertAnimType.slideInUp,
              borderRadius: 25,
              title: "Login Failed",
              text: e.toString(),
              textColor: Colors.white,
              backgroundColor: Colors.grey.shade900,
              showConfirmBtn: true,
              confirmBtnText: "OK",
            );
        }
      }
    }
  }

  void _fillDemoCredentials() {
    setState(() {
      _emailController.text = _demoEmail;
      _passwordController.text = _demoPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40),

                  // Logo
                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: AppColors.primaryGradient,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // App Name
                  Center(
                    child: GradientText(
                      'Welcome Back',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                      ),
                      colors: AppColors.primaryGradient,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: Icon(
                        LineIcons.envelope,
                        color: AppColors.primary,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.shade800,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: Icon(
                        LineIcons.lock,
                        color: AppColors.primary,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? LineIcons.eye
                              : LineIcons.eyeSlash,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade900,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.grey.shade800,
                          width: 1,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),

                  // Forgot Password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () async {
                        if (_emailController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Please enter your email first'),
                              backgroundColor: Colors.orangeAccent,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          return;
                        }

                        try {
                          await _authService.sendPasswordResetEmail(
                            _emailController.text.trim(),
                          );
                          if (mounted) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              animType: QuickAlertAnimType.slideInUp,
                              borderRadius: 25,
                              title: "Email Sent",
                              text: "Password reset link has been sent to your email.",
                              textColor: Colors.white,
                              backgroundColor: Colors.grey.shade900,
                              showConfirmBtn: true,
                              confirmBtnText: "OK",
                            );
                          }
                        } catch (e) {
                          if (mounted) {
                            QuickAlert.show(
                              context: context,
                              type: QuickAlertType.error,
                              animType: QuickAlertAnimType.slideInUp,
                              borderRadius: 25,
                              title: "Error",
                              text: e.toString(),
                              textColor: Colors.white,
                              backgroundColor: Colors.grey.shade900,
                              showConfirmBtn: true,
                              confirmBtnText: "OK",
                            );
                          }
                        }
                      },
                      child: Text(
                        'Forgot Password?',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Login Button
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                      shadowColor: AppColors.primary.withOpacity(0.5),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text(
                            'Sign In',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),

                  const SizedBox(height: 24),

                  // Demo Credentials Button
                  OutlinedButton.icon(
                    onPressed: _fillDemoCredentials,
                    icon: const Icon(LineIcons.magic),
                    label: const Text('Use Demo Credentials'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      side: const BorderSide(color: AppColors.primary, width: 1.5),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Divider
                  Row(
                    children: [
                      Expanded(
                        child: Divider(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          color: Colors.white.withOpacity(0.1),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: GradientText(
                          'Sign Up',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          colors: AppColors.primaryGradient,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

