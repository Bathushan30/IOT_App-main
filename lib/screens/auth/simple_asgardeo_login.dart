import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/screens/auth/register.dart';
import 'package:iot/utils/app_colors.dart';
import 'package:iot/services/mock_asgardeo_auth.dart';
import 'package:quickalert/quickalert.dart';

class SimpleAsgardeoLoginScreen extends StatefulWidget {
  const SimpleAsgardeoLoginScreen({super.key});

  @override
  State<SimpleAsgardeoLoginScreen> createState() => _SimpleAsgardeoLoginScreenState();
}

class _SimpleAsgardeoLoginScreenState extends State<SimpleAsgardeoLoginScreen> {
  final _asgardeoAuth = MockAsgardeoAuth();
  bool _isLoading = false;

  Future<void> _handleAsgardeoLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final success = await _asgardeoAuth.signIn();
      
      if (success) {
        if (mounted) {
          QuickAlert.show(
            context: context,
            type: QuickAlertType.info,
            animType: QuickAlertAnimType.slideInUp,
            borderRadius: 25,
            title: "Authentication Started",
            text: "Please complete authentication in your browser and return to the app.",
            textColor: Colors.white,
            backgroundColor: Colors.grey.shade900,
            showConfirmBtn: true,
            confirmBtnText: "OK",
          );
        }
      }
    } catch (e) {
      if (mounted) {
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          animType: QuickAlertAnimType.slideInUp,
          borderRadius: 25,
          title: "Authentication Failed",
          text: e.toString(),
          textColor: Colors.white,
          backgroundColor: Colors.grey.shade900,
          showConfirmBtn: true,
          confirmBtnText: "OK",
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
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
                    'Welcome to ProHome',
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
                    'Secure IoT Control System',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.6),
                    ),
                  ),
                ),

                const SizedBox(height: 48),

                // Asgardeo Login Button
                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _handleAsgardeoLogin,
                  icon: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                          ),
                        )
                      : const Icon(LineIcons.lock),
                  label: Text(
                    _isLoading ? 'Authenticating...' : 'Sign in with Asgardeo',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),

                const SizedBox(height: 24),

                // Configuration Status
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.green.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        LineIcons.checkCircle,
                        color: Colors.green,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Asgardeo Configured',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Ready to authenticate with Asgardeo',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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

                // Fallback to traditional login
                OutlinedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterScreen(),
                      ),
                    );
                  },
                  icon: const Icon(LineIcons.user),
                  label: const Text('Use Traditional Login'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}