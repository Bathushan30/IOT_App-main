import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/screens/auth/asgardeo_signup.dart';
import 'package:iot/rootnavigator.dart';
import 'package:iot/utils/app_colors.dart';
import 'package:iot/services/asgardeo_service.dart';
import 'package:quickalert/quickalert.dart';

class AsgardeoSignInScreen extends StatefulWidget {
  const AsgardeoSignInScreen({super.key});

  @override
  State<AsgardeoSignInScreen> createState() => _AsgardeoSignInScreenState();
}

class _AsgardeoSignInScreenState extends State<AsgardeoSignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _asgardeoService = AsgardeoService();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
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
                      'Welcome Back',
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900),
                      colors: AppColors.primaryGradient,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Sign in with Asgardeo',
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
                        return 'Please enter your username';
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
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleSignIn,
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
                        : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  ),

                  const SizedBox(height: 32),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account? ", style: TextStyle(color: Colors.white.withOpacity(0.6))),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AsgardeoSignUpScreen()),
                          );
                        },
                        child: GradientText(
                          'Sign Up',
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