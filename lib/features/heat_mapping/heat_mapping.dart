import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/utils/app_colors.dart';

class HeatMapping extends StatefulWidget {
  const HeatMapping({super.key});

  @override
  State<HeatMapping> createState() => _HeatMappingState();
}

class _HeatMappingState extends State<HeatMapping> with SingleTickerProviderStateMixin {
  String _selectedView = 'Energy';
  final List<String> _views = ['Energy', 'Activity', 'Temperature'];
  bool _isRealTime = true;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<Map<String, dynamic>> _rooms = [
    {
      'name': 'Living Room',
      'energy': 85,
      'activity': 92,
      'temperature': 22,
      'devices': 3,
      'x': 0.3,
      'y': 0.2,
    },
    {
      'name': 'Bed Room',
      'energy': 45,
      'activity': 35,
      'temperature': 24,
      'devices': 2,
      'x': 0.7,
      'y': 0.2,
    },
    {
      'name': 'Kitchen',
      'energy': 65,
      'activity': 78,
      'temperature': 26,
      'devices': 2,
      'x': 0.2,
      'y': 0.6,
    },
    {
      'name': 'Office',
      'energy': 35,
      'activity': 25,
      'temperature': 23,
      'devices': 1,
      'x': 0.8,
      'y': 0.6,
    },
  ];

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

  Color _getHeatColor(int value) {
    if (value >= 80) return Colors.redAccent;
    if (value >= 60) return Colors.orangeAccent;
    if (value >= 40) return Colors.yellowAccent;
    if (value >= 20) return Colors.greenAccent;
    return Colors.blueAccent;
  }

  int _getRoomValue(Map<String, dynamic> room) {
    switch (_selectedView) {
      case 'Energy':
        return room['energy'] as int;
      case 'Activity':
        return room['activity'] as int;
      case 'Temperature':
        return room['temperature'] as int;
      default:
        return room['energy'] as int;
    }
  }

  String _getUnit() {
    switch (_selectedView) {
      case 'Energy':
        return '%';
      case 'Activity':
        return '%';
      case 'Temperature':
        return '°C';
      default:
        return '%';
    }
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
                child: Column(
                  children: [
                    // Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              LineIcons.arrowLeft,
                              color: AppColors.primary,
                              size: 28,
                            ),
                          ),
                          Expanded(
                            child: GradientText(
                              'Heat Mapping',
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                              ),
                              colors: AppColors.primaryGradient,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _isRealTime
                                  ? Colors.greenAccent.withOpacity(0.2)
                                  : AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _isRealTime
                                    ? Colors.greenAccent.withOpacity(0.5)
                                    : Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isRealTime ? LineIcons.circle : LineIcons.pause,
                                  color: _isRealTime ? Colors.greenAccent : Colors.white54,
                                  size: 12,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _isRealTime ? 'Live' : 'Paused',
                                  style: TextStyle(
                                    color: _isRealTime ? Colors.greenAccent : Colors.white54,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Switch(
                            value: _isRealTime,
                            onChanged: (value) {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _isRealTime = value;
                              });
                            },
                            activeColor: AppColors.primary,
                          ),
                        ],
                      ),
                    ),

                    // View Selector
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.primary.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: _views.map((view) {
                            final isSelected = _selectedView == view;
                            return Expanded(
                              child: InkWell(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  setState(() {
                                    _selectedView = view;
                                  });
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    gradient: isSelected
                                        ? LinearGradient(colors: AppColors.primaryGradient)
                                        : null,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    view,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: isSelected ? Colors.white : Colors.white.withOpacity(0.6),
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Heat Map Visualization
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            // Heat Map Grid
                            Container(
                              height: 400,
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Stack(
                                children: _rooms.map((room) {
                                  final value = _getRoomValue(room);
                                  final color = _getHeatColor(value);
                                  return Positioned(
                                    left: room['x'] * 320,
                                    top: room['y'] * 340,
                                    child: GestureDetector(
                                      onTap: () {
                                        HapticFeedback.mediumImpact();
                                        _showRoomDetails(room);
                                      },
                                      child: Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          color: color.withOpacity(0.7),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: color, width: 3),
                                          boxShadow: [
                                            BoxShadow(
                                              color: color.withOpacity(0.5),
                                              blurRadius: 20,
                                              spreadRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                '$value${_getUnit()}',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Icon(
                                                Icons.home_rounded,
                                                size: 16,
                                                color: Colors.white.withOpacity(0.8),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Legend
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Icon(LineIcons.infoCircle, color: AppColors.primary, size: 20),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Heat Intensity',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      _buildLegendItem(Colors.redAccent, 'High (80%+)'),
                                      const SizedBox(width: 12),
                                      _buildLegendItem(Colors.orangeAccent, 'Medium (60%)'),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildLegendItem(Colors.yellowAccent, 'Low (40%)'),
                                      const SizedBox(width: 12),
                                      _buildLegendItem(Colors.greenAccent, 'Min (20%)'),
                                    ],
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Room List
                            const Text(
                              'Room Details',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),

                            const SizedBox(height: 12),

                            ..._rooms.map((room) => _buildRoomCard(room)),

                            const SizedBox(height: 24),
                          ],
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
    );
  }

  Widget _buildLegendItem(Color color, String label) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoomCard(Map<String, dynamic> room) {
    final value = _getRoomValue(room);
    final color = _getHeatColor(value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          HapticFeedback.lightImpact();
          _showRoomDetails(room);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: color.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '$value${_getUnit()}',
                    style: TextStyle(
                      color: color,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      room['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${room['devices']} devices connected',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                LineIcons.chevronRight,
                color: color,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showRoomDetails(Map<String, dynamic> room) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.surface,
              const Color(0xFF1A1F3A),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: AppColors.primary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.home_rounded,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    room['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailRow('Energy Usage', '${room['energy']}%', Colors.blueAccent),
            _buildDetailRow('Activity Level', '${room['activity']}%', Colors.greenAccent),
            _buildDetailRow('Temperature', '${room['temperature']}°C', Colors.orangeAccent),
            _buildDetailRow('Connected Devices', '${room['devices']}', AppColors.primary),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}