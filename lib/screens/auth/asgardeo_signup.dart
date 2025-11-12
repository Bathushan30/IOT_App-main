import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/rootnavigator.dart';
import 'package:iot/utils/app_colors.dart';
import 'package:iot/services/asgardeo_service.dart';
import 'package:quickalert/quickalert.dart';

class AsgardeoSignUpScreen extends StatefulWidget {
  const AsgardeoSignUpScreen({super.key});

  @override
  State<AsgardeoSignUpScreen> createState() => _AsgardeoSignUpScreenState();
}

class _AsgardeoSignUpScreenState extends State<AsgardeoSignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _asgardeoService = AsgardeoService();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        await Future.delayed(const Duration(seconds: 1));

        if (mounted) {
          setState(() => _isLoading = false);

          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            animType: QuickAlertAnimType.slideInUp,
            borderRadius: 25,
            title: "Account Created",
            text: "Welcome to ProHome IoT!",
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
        if (mounted) {
          setState(() => _isLoading = false);
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
    }
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

                  Center(
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: AppColors.primaryGradient),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(Icons.home_rounded, size: 40, color: Colors.white),
                    ),
                  ),

                  const SizedBox(height: 32),

                  Center(
                    child: GradientText(
                      'Create Account',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                      colors: AppColors.primaryGradient,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Sign up with Asgardeo',
                      style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.6)),
                    ),
                  ),

                  const SizedBox(height: 48),

                  TextFormField(
                    controller: _usernameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(LineIcons.user, color: AppColors.primary),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(LineIcons.envelope, color: AppColors.primary),
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

                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscurePassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(LineIcons.lock, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? LineIcons.eye : LineIcons.eyeSlash,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: _obscureConfirmPassword,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(LineIcons.lock, color: AppColors.primary),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? LineIcons.eye : LineIcons.eyeSlash,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Sign Up', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already have an account? ", style: TextStyle(color: Colors.white.withOpacity(0.6))),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: GradientText(
                          'Sign In',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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