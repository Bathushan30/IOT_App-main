import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/utils/app_colors.dart';
import 'package:intl/intl.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int totalDevices = 4;
  int activeDevices = 2;
  double energyUsage = 84.8;
  String currentTime = "Good Evening";
  String currentUser = "Bathushan30";
  String currentDateTime = "";
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  List<Map<String, dynamic>> rooms = [
    {
      'name': 'Living Room',
      'devices': 2,
      'active': 1,
      'icon': LineIcons.home,
      'temperature': '22°C',
      'status': 'Comfortable',
    },
    {
      'name': 'Bed Room',
      'devices': 1,
      'active': 1,
      'icon': LineIcons.bed,
      'temperature': '20°C',
      'status': 'Sleep Mode',
    },
    {
      'name': 'Office',
      'devices': 1,
      'active': 0,
      'icon': LineIcons.briefcase,
      'temperature': '24°C',
      'status': 'Inactive',
    },
  ];

  @override
  void initState() {
    super.initState();
    _updateGreeting();
    _updateDateTime();
    
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
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

  void _updateGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      setState(() {
        currentTime = "Good Morning";
      });
    } else if (hour < 17) {
      setState(() {
        currentTime = "Good Afternoon";
      });
    } else {
      setState(() {
        currentTime = "Good Evening";
      });
    }
  }

  void _updateDateTime() {
    final now = DateTime.now();
    setState(() {
      currentDateTime = DateFormat('EEEE, MMM dd, yyyy • HH:mm').format(now);
    });
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
            child: RefreshIndicator(
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              onRefresh: () async {
                HapticFeedback.mediumImpact();
                _updateGreeting();
                _updateDateTime();
                setState(() {
                  _animationController.reset();
                  _animationController.forward();
                });
                await Future.delayed(const Duration(milliseconds: 600));
              },
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                slivers: [
                  SliverToBoxAdapter(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Section
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            GradientText(
                                              'BledsoeTech',
                                              style: const TextStyle(
                                                fontSize: 32,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1,
                                              ),
                                              colors: AppColors.primaryGradient,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Welcome back, $currentUser',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white.withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: AppColors.primaryGradient,
                                          ),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(
                                            color: AppColors.primary.withOpacity(0.3),
                                            width: 1,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppColors.primary.withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                        child: const Icon(
                                          LineIcons.user,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Icon(
                                        _getGreetingIcon(),
                                        color: AppColors.primary,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              currentTime,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white.withOpacity(0.9),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              currentDateTime,
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                                color: AppColors.primary.withOpacity(0.8),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            // Statistics Cards
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Total Devices',
                                      value: totalDevices.toString(),
                                      icon: LineIcons.plug,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildStatCard(
                                      title: 'Active Now',
                                      value: activeDevices.toString(),
                                      icon: LineIcons.checkCircle,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 20),

                            // Energy Usage Card
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Row(
                                        children: [
                                          Icon(Icons.bolt_rounded, color: AppColors.primary),
                                          const SizedBox(width: 12),
                                          const Text('Energy details coming soon!'),
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
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.primary.withOpacity(0.3),
                                        AppColors.primary.withOpacity(0.1),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: AppColors.primary.withOpacity(0.3),
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.2),
                                        blurRadius: 20,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.3),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.bolt_rounded,
                                          size: 32,
                                          color: AppColors.primary,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  '$energyUsage kWh',
                                                  style: const TextStyle(
                                                    fontSize: 26,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                Container(
                                                  padding: const EdgeInsets.symmetric(
                                                    horizontal: 8,
                                                    vertical: 4,
                                                  ),
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      colors: AppColors.primaryGradient,
                                                    ),
                                                    borderRadius: BorderRadius.circular(8),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: const [
                                                      Icon(
                                                        LineIcons.circle,
                                                        size: 8,
                                                        color: Colors.white,
                                                      ),
                                                      SizedBox(width: 4),
                                                      Text(
                                                        'LIVE',
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w700,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Energy usage this month',
                                              style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        LineIcons.arrowRight,
                                        color: AppColors.primary,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Rooms Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Rooms',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  TextButton.icon(
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: const Text('All rooms view coming soon!'),
                                          backgroundColor: AppColors.surface,
                                          behavior: SnackBarBehavior.floating,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(
                                      LineIcons.arrowRight,
                                      color: AppColors.primary,
                                      size: 16,
                                    ),
                                    label: Text(
                                      'See All',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Rooms List
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: rooms.map((room) {
                                  final isActive = room['active'] > 0;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: InkWell(
                                      onTap: () {
                                        HapticFeedback.lightImpact();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Opening ${room['name']}...'),
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
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: isActive
                                                ? [
                                                    AppColors.primary.withOpacity(0.2),
                                                    AppColors.primary.withOpacity(0.05),
                                                  ]
                                                : [
                                                    AppColors.surface,
                                                    AppColors.surface.withOpacity(0.8),
                                                  ],
                                          ),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isActive 
                                                ? AppColors.primary.withOpacity(0.4)
                                                : Colors.white.withOpacity(0.1),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: isActive
                                                  ? AppColors.primary.withOpacity(0.15)
                                                  : Colors.black.withOpacity(0.2),
                                              blurRadius: 20,
                                              spreadRadius: isActive ? 2 : 0,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  padding: const EdgeInsets.all(14),
                                                  decoration: BoxDecoration(
                                                    gradient: isActive
                                                        ? LinearGradient(
                                                            colors: AppColors.primaryGradient,
                                                          )
                                                        : null,
                                                    color: isActive 
                                                        ? null 
                                                        : Colors.white.withOpacity(0.05),
                                                    borderRadius: BorderRadius.circular(14),
                                                    boxShadow: isActive
                                                        ? [
                                                            BoxShadow(
                                                              color: AppColors.primary.withOpacity(0.4),
                                                              blurRadius: 12,
                                                              spreadRadius: 2,
                                                            ),
                                                          ]
                                                        : null,
                                                  ),
                                                  child: Icon(
                                                    room['icon'],
                                                    size: 28,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(width: 16),
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              room['name'],
                                                              style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight: FontWeight.w700,
                                                                color: Colors.white,
                                                              ),
                                                            ),
                                                          ),
                                                          Container(
                                                            padding: const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 4,
                                                            ),
                                                            decoration: BoxDecoration(
                                                              gradient: isActive
                                                                  ? LinearGradient(
                                                                      colors: AppColors.primaryGradient,
                                                                    )
                                                                  : null,
                                                              color: isActive
                                                                  ? null
                                                                  : Colors.white.withOpacity(0.1),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                            child: Text(
                                                              isActive ? 'ACTIVE' : 'OFF',
                                                              style: TextStyle(
                                                                fontSize: 10,
                                                                fontWeight: FontWeight.w700,
                                                                color: isActive
                                                                    ? Colors.white
                                                                    : Colors.white.withOpacity(0.5),
                                                                letterSpacing: 0.5,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        room['status'],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                          color: isActive
                                                              ? AppColors.primary.withOpacity(0.9)
                                                              : Colors.white.withOpacity(0.5),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Container(
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.05),
                                                borderRadius: BorderRadius.circular(12),
                                                border: Border.all(
                                                  color: isActive
                                                      ? AppColors.primary.withOpacity(0.2)
                                                      : Colors.white.withOpacity(0.05),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        LineIcons.plug,
                                                        size: 16,
                                                        color: AppColors.primary.withOpacity(0.8),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        '${room['devices']} Devices',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white.withOpacity(0.7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 16,
                                                    color: Colors.white.withOpacity(0.1),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        LineIcons.thermometerEmpty,
                                                        size: 16,
                                                        color: AppColors.primary.withOpacity(0.8),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        room['temperature'],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white.withOpacity(0.7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 1,
                                                    height: 16,
                                                    color: Colors.white.withOpacity(0.1),
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        isActive ? LineIcons.checkCircle : LineIcons.circle,
                                                        size: 16,
                                                        color: isActive
                                                            ? AppColors.primary
                                                            : Colors.white.withOpacity(0.3),
                                                      ),
                                                      const SizedBox(width: 6),
                                                      Text(
                                                        '${room['active']}/${room['devices']}',
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w600,
                                                          color: Colors.white.withOpacity(0.7),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Advanced Features Section
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Text(
                                'Advanced Features',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Advanced Feature Cards
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Column(
                                children: [
                                  _buildFeatureCard(
                                    icon: LineIcons.search,
                                    title: 'Anomaly Hunter',
                                    subtitle: 'Detect unusual patterns in real-time',
                                    badge: 'AI',
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pushNamed(context, '/anomaly-hunter');
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _buildFeatureCard(
                                    icon: LineIcons.brain,
                                    title: 'Predictive Core',
                                    subtitle: 'AI-powered usage predictions',
                                    badge: 'NEW',
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pushNamed(context, '/predictive-core');
                                    },
                                  ),
                                  const SizedBox(height: 12),
                                  _buildFeatureCard(
                                    icon: LineIcons.fire,
                                    title: 'Heat Mapping',
                                    subtitle: 'Visual energy consumption analysis',
                                    badge: 'LIVE',
                                    onTap: () {
                                      HapticFeedback.mediumImpact();
                                      Navigator.pushNamed(context, '/heat-mapping');
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Quick Actions
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: const Text(
                                'Quick Actions',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Quick Action Buttons
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickAction(
                                      icon: LineIcons.lightbulb,
                                      label: 'All Lights',
                                      onTap: () {
                                        HapticFeedback.heavyImpact();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(LineIcons.lightbulb, color: AppColors.primary),
                                                const SizedBox(width: 12),
                                                const Text('All lights toggled!'),
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
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildQuickAction(
                                      icon: LineIcons.powerOff,
                                      label: 'Turn Off All',
                                      onTap: () {
                                        HapticFeedback.heavyImpact();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                Icon(LineIcons.powerOff, color: AppColors.primary),
                                                const SizedBox(width: 12),
                                                const Text('All devices turned off!'),
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
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),
                          ],
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
    );
  }

  IconData _getGreetingIcon() {
    final hour = DateTime.now().hour;
    if (hour < 12) return LineIcons.sun;
    if (hour < 17) return LineIcons.cloud;
    return LineIcons.moon;
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.2),
            AppColors.primary.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 12,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, size: 24, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.2),
              AppColors.primary.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(icon, size: 32, color: Colors.white),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required String badge,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary.withOpacity(0.15),
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
              color: AppColors.primary.withOpacity(0.15),
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: AppColors.primaryGradient,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.5),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Icon(icon, size: 28, color: Colors.white),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: AppColors.primaryGradient,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          badge,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.6),
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                LineIcons.chevronRight,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}