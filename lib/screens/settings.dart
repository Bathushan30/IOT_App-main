import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/utils/app_colors.dart';
import 'package:iot/services/auth_service.dart';
import 'package:iot/screens/auth/login.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  bool notificationsEnabled = true;
  bool darkModeEnabled = true;
  bool autoSyncEnabled = true;
  String selectedLanguage = 'English';
  String selectedTheme = 'Dark';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeIn,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOutCubic,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0A0E27),
                const Color(0xFF1A1F3A),
                const Color(0xFF0D1226),
              ],
            ),
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Section
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GradientText(
                              'Settings',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.w900,
                              ),
                              colors: AppColors.primaryGradient,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Manage your app preferences',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Profile Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: InkWell(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Profile edit coming soon!'),
                                backgroundColor: AppColors.surface,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withOpacity(0.2),
                                  AppColors.primary.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: AppColors.primaryGradient,
                                    ),
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    LineIcons.user,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _authService.currentUserName ?? 'Bathushan30',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _authService.currentUserEmail ?? 'bathushan30@bledsoeTech.com',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Colors.white.withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  LineIcons.chevronRight,
                                  color: AppColors.primary,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Settings Categories
                      _buildSectionTitle('Preferences'),

                      // Notifications
                      _buildSettingTile(
                        icon: LineIcons.bell,
                        title: 'Notifications',
                        subtitle: 'Enable push notifications',
                        trailing: Switch(
                          value: notificationsEnabled,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              notificationsEnabled = value;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      value ? LineIcons.checkCircle : LineIcons.timesCircle,
                                      color: value ? Colors.greenAccent : Colors.redAccent,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(value ? 'Notifications enabled' : 'Notifications disabled'),
                                  ],
                                ),
                                backgroundColor: AppColors.surface,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),

                      // Auto Sync
                      _buildSettingTile(
                        icon: LineIcons.cloud,
                        title: 'Auto Sync',
                        subtitle: 'Automatically sync device data',
                        trailing: Switch(
                          value: autoSyncEnabled,
                          onChanged: (value) {
                            HapticFeedback.selectionClick();
                            setState(() {
                              autoSyncEnabled = value;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Row(
                                  children: [
                                    Icon(
                                      value ? LineIcons.checkCircle : LineIcons.timesCircle,
                                      color: value ? Colors.greenAccent : Colors.redAccent,
                                    ),
                                    const SizedBox(width: 12),
                                    Text(value ? 'Auto sync enabled' : 'Auto sync disabled'),
                                  ],
                                ),
                                backgroundColor: AppColors.surface,
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          },
                          activeColor: AppColors.primary,
                        ),
                      ),

                      const SizedBox(height: 24),

                      _buildSectionTitle('Appearance'),

                      // Theme
                      _buildSettingTile(
                        icon: LineIcons.palette,
                        title: 'Theme',
                        subtitle: selectedTheme,
                        trailing: Icon(
                          LineIcons.chevronRight,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showThemeDialog();
                        },
                      ),

                      // Language
                      _buildSettingTile(
                        icon: LineIcons.language,
                        title: 'Language',
                        subtitle: selectedLanguage,
                        trailing: Icon(
                          LineIcons.chevronRight,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          _showLanguageDialog();
                        },
                      ),

                      const SizedBox(height: 24),

                      _buildSectionTitle('Device Management'),

                      // Connected Devices
                      _buildSettingTile(
                        icon: LineIcons.plug,
                        title: 'Connected Devices',
                        subtitle: '4 devices connected',
                        trailing: Icon(
                          LineIcons.chevronRight,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Device management coming soon!'),
                              backgroundColor: AppColors.surface,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),

                      // Add Device
                      _buildSettingTile(
                        icon: LineIcons.plusCircle,
                        title: 'Add Device',
                        subtitle: 'Connect a new smart device',
                        trailing: Icon(
                          LineIcons.chevronRight,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Add device coming soon!'),
                              backgroundColor: AppColors.surface,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      _buildSectionTitle('About'),

                      // App Version
                      _buildSettingTile(
                        icon: LineIcons.infoCircle,
                        title: 'App Version',
                        subtitle: '1.0.0',
                        trailing: const SizedBox.shrink(),
                      ),

                      // Help & Support
                      _buildSettingTile(
                        icon: LineIcons.questionCircle,
                        title: 'Help & Support',
                        subtitle: 'Get help and contact support',
                        trailing: Icon(
                          LineIcons.chevronRight,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Support page coming soon!'),
                              backgroundColor: AppColors.surface,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),

                      // Privacy Policy
                      _buildSettingTile(
                        icon: LineIcons.lock,
                        title: 'Privacy Policy',
                        subtitle: 'View our privacy policy',
                        trailing: Icon(
                          LineIcons.chevronRight,
                          color: AppColors.primary,
                          size: 20,
                        ),
                        onTap: () {
                          HapticFeedback.lightImpact();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Privacy policy coming soon!'),
                              backgroundColor: AppColors.surface,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          );
                        },
                      ),

                      // Logout Button
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.redAccent.withOpacity(0.3),
                                Colors.redAccent.withOpacity(0.1),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.redAccent.withOpacity(0.5),
                              width: 2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.redAccent.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                HapticFeedback.heavyImpact();
                                _showLogoutDialog();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 18),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Icon(
                                      LineIcons.alternateSignOut,
                                      color: Colors.redAccent,
                                      size: 24,
                                    ),
                                    SizedBox(width: 12),
                                    Text(
                                      'Logout',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.redAccent,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.primary.withOpacity(0.8),
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.05),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: AppColors.primaryGradient,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                trailing,
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showThemeDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            Icon(LineIcons.palette, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(
              'Select Theme',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('Dark', Colors.black),
            const SizedBox(height: 12),
            _buildThemeOption('Light', Colors.white),
            const SizedBox(height: 12),
            _buildThemeOption('System', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeOption(String name, Color color) {
    final isSelected = selectedTheme == name;
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          selectedTheme = name;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(LineIcons.checkCircle, color: AppColors.primary),
                const SizedBox(width: 12),
                Text('Theme changed to $name'),
              ],
            ),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: AppColors.primaryGradient) : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                LineIcons.check,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    HapticFeedback.mediumImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        title: Row(
          children: [
            Icon(LineIcons.language, color: AppColors.primary),
            const SizedBox(width: 12),
            const Text(
              'Select Language',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('English'),
            const SizedBox(height: 12),
            _buildLanguageOption('Spanish'),
            const SizedBox(height: 12),
            _buildLanguageOption('French'),
            const SizedBox(height: 12),
            _buildLanguageOption('German'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = selectedLanguage == language;
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          selectedLanguage = language;
        });
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(LineIcons.checkCircle, color: AppColors.primary),
                const SizedBox(width: 12),
                Text('Language changed to $language'),
              ],
            ),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? LinearGradient(colors: AppColors.primaryGradient) : null,
          color: isSelected ? null : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.white.withOpacity(0.1),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(
              language,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            if (isSelected)
              const Icon(
                LineIcons.check,
                color: Colors.white,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.redAccent.withOpacity(0.5),
              width: 1.5,
            ),
          ),
          title: Row(
            children: const [
              Icon(LineIcons.exclamationTriangle, color: Colors.redAccent, size: 28),
              SizedBox(width: 12),
              Text(
                'Logout',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          content: const Text(
            'Are you sure you want to logout from your account?',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 15,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.of(dialogContext).pop();
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.redAccent, Colors.red],
                ),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextButton(
                onPressed: () async {
                  HapticFeedback.heavyImpact();
                  
                  // Close the dialog
                  Navigator.of(dialogContext).pop();
                  
                  // Sign out
                  await _authService.signOut();
                  
                  // Small delay
                  await Future.delayed(const Duration(milliseconds: 200));
                  
                  // Navigate to login - use the widget's context
                  if (mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (_) => const LoginScreen(),
                      ),
                      (route) => false,
                    );
                  }
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}