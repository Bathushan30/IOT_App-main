import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iot/utils/device_button.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import 'package:line_icons/line_icons.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'package:iot/utils/app_colors.dart';

class Controls extends StatefulWidget {
  const Controls({super.key});
  @override
  State<Controls> createState() => _ControlsState();
}

class _ControlsState extends State<Controls> with SingleTickerProviderStateMixin {
  bool apiConnectionStatus = false;
  final Set<int> _busyDeviceIndexes = {};
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  List smartDevices = [
    [
      const Icon(LineIcons.lightbulb, size: 35, color: Colors.white),
      "Night Light",
      "Bed Room",
      false,
    ],
    [
      const Icon(LineIcons.wifi, size: 35, color: Colors.white),
      "Wifi",
      "Office",
      false,
    ],
    [
      const Icon(LineIcons.television, size: 35, color: Colors.white),
      "TV",
      "Home",
      false,
    ],
    [
      const Icon(LineIcons.snowflake, size: 35, color: Colors.white),
      "AC",
      "Living Room",
      false,
    ],
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

  void onPowerChange(bool value, int index) async {
    if (!apiConnectionStatus) {
      HapticFeedback.mediumImpact();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.warning,
        animType: QuickAlertAnimType.slideInUp,
        borderRadius: 25,
        title: "Server Not Connected",
        text: "Please connect to the IoT server first to control devices.",
        textColor: Colors.white,
        backgroundColor: AppColors.surface,
        confirmBtnColor: AppColors.primary,
        showConfirmBtn: true,
        confirmBtnText: "Connect Now",
        onConfirmBtnTap: () async {
          Navigator.pop(context);
          await connectServer();
        },
      );
    } else {
      if (_busyDeviceIndexes.contains(index)) {
        HapticFeedback.selectionClick();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                ),
                SizedBox(width: 12),
                Text('Processing previous action...'),
              ],
            ),
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }
      
      _busyDeviceIndexes.add(index);
      HapticFeedback.heavyImpact();
      
      setState(() {
        smartDevices[index][3] = value;
      });
      
      try {
        await _toggleWithRetry(
          baseUrl: "https://c949-2401-4900-1c37-9db5-9c7b-7d39-aae9-1025.ngrok-free.app",
          desiredState: smartDevices[index][3],
          maxAttempts: 3,
        );
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(
                    smartDevices[index][3] ? LineIcons.checkCircle : LineIcons.powerOff,
                    color: smartDevices[index][3] ? Colors.greenAccent : Colors.redAccent,
                  ),
                  const SizedBox(width: 12),
                  Text(smartDevices[index][3] ? 'Device turned on' : 'Device turned off'),
                ],
              ),
              backgroundColor: AppColors.surface,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (error) {
        setState(() {
          smartDevices[index][3] = !value;
        });
        
        if (context.mounted) {
          HapticFeedback.vibrate();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.error,
            animType: QuickAlertAnimType.slideInUp,
            borderRadius: 25,
            title: "Action Failed",
            text: "Unable to control device. Please try again.",
            textColor: Colors.white,
            backgroundColor: AppColors.surface,
            confirmBtnColor: Colors.redAccent,
            showConfirmBtn: true,
            confirmBtnText: "OK",
          );
        }
      } finally {
        _busyDeviceIndexes.remove(index);
      }
    }
  }

  Future<Map<String, dynamic>> connectServer() async {
    try {
      HapticFeedback.mediumImpact();
      QuickAlert.show(
        context: context,
        type: QuickAlertType.loading,
        animType: QuickAlertAnimType.slideInUp,
        borderRadius: 25,
        title: "Connecting to server...",
        text: "Please wait a few seconds.",
        textColor: Colors.white,
        backgroundColor: AppColors.surface,
        showConfirmBtn: false,
      );
      
      final response = await http.get(
        Uri.parse("https://c949-2401-4900-1c37-9db5-9c7b-7d39-aae9-1025.ngrok-free.app")
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        
        if (context.mounted) {
          Navigator.pop(context);
          HapticFeedback.heavyImpact();
          QuickAlert.show(
            context: context,
            type: QuickAlertType.success,
            animType: QuickAlertAnimType.slideInUp,
            borderRadius: 25,
            title: "Server Connected",
            text: "You can now control your devices.",
            textColor: Colors.white,
            backgroundColor: AppColors.surface,
            confirmBtnColor: Colors.greenAccent,
            showConfirmBtn: true,
            confirmBtnText: "Great!",
          );
        }
        
        setState(() {
          apiConnectionStatus = true;
        });
        return data;
      } else {
        throw Exception('Failed to load data');
      }
    } catch (error) {
      if (context.mounted) {
        Navigator.pop(context);
        HapticFeedback.vibrate();
        QuickAlert.show(
          context: context,
          type: QuickAlertType.error,
          animType: QuickAlertAnimType.slideInUp,
          borderRadius: 25,
          title: "Connection Failed",
          text: "Unable to connect to server. Please check your connection and try again.",
          textColor: Colors.white,
          backgroundColor: AppColors.surface,
          confirmBtnColor: Colors.redAccent,
          showConfirmBtn: true,
          confirmBtnText: "OK",
        );
      }
      
      setState(() {
        apiConnectionStatus = false;
      });
      return {};
    }
  }

  Future<Map<String, dynamic>> toggleLight(String apiendpoint, bool currVal) async {
    try {
      if (currVal) {
        apiendpoint = "https://c949-2401-4900-1c37-9db5-9c7b-7d39-aae9-1025.ngrok-free.app/turn-off";
      } else {
        apiendpoint = "https://c949-2401-4900-1c37-9db5-9c7b-7d39-aae9-1025.ngrok-free.app/turn-on";
      }
      
      final response = await http.get(Uri.parse(apiendpoint));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        throw Exception('Failed to load data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _toggleWithRetry({
    required String baseUrl,
    required bool desiredState,
    int maxAttempts = 3,
  }) async {
    int attempt = 0;
    while (true) {
      attempt++;
      try {
        await toggleLight(baseUrl, desiredState);
        return;
      } catch (e) {
        if (attempt >= maxAttempts) rethrow;
        final backoffMs = 300 * attempt;
        await Future.delayed(Duration(milliseconds: backoffMs));
      }
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GradientText(
                            'Device Control',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                            ),
                            colors: AppColors.primaryGradient,
                          ),
                          InkWell(
                            onTap: () async {
                              HapticFeedback.mediumImpact();
                              if (!apiConnectionStatus) {
                                await connectServer();
                              } else {
                                setState(() {
                                  apiConnectionStatus = false;
                                });
                                
                                if (context.mounted) {
                                  QuickAlert.show(
                                    context: context,
                                    type: QuickAlertType.info,
                                    animType: QuickAlertAnimType.slideInUp,
                                    borderRadius: 25,
                                    title: "Server Disconnected",
                                    text: "Server connection has been disconnected.",
                                    textColor: Colors.white,
                                    backgroundColor: AppColors.surface,
                                    confirmBtnColor: AppColors.primary,
                                    showConfirmBtn: true,
                                    confirmBtnText: "OK",
                                  );
                                }
                              }
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: apiConnectionStatus
                                    ? Colors.greenAccent.withOpacity(0.2)
                                    : AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: apiConnectionStatus
                                      ? Colors.greenAccent.withOpacity(0.5)
                                      : AppColors.primary.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                apiConnectionStatus ? LineIcons.server : LineIcons.powerOff,
                                size: 24,
                                color: apiConnectionStatus ? Colors.greenAccent : AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Server Status Card
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: InkWell(
                        onTap: () async {
                          if (!apiConnectionStatus) {
                            await connectServer();
                          }
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: apiConnectionStatus
                                  ? [
                                      Colors.greenAccent.withOpacity(0.2),
                                      Colors.greenAccent.withOpacity(0.05),
                                    ]
                                  : [
                                      Colors.redAccent.withOpacity(0.2),
                                      Colors.redAccent.withOpacity(0.05),
                                    ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: apiConnectionStatus
                                  ? Colors.greenAccent.withOpacity(0.3)
                                  : Colors.redAccent.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: (apiConnectionStatus ? Colors.greenAccent : Colors.redAccent)
                                    .withOpacity(0.2),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: (apiConnectionStatus ? Colors.greenAccent : Colors.redAccent)
                                      .withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.bolt_rounded,
                                  size: 32,
                                  color: apiConnectionStatus ? Colors.greenAccent : Colors.redAccent,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      apiConnectionStatus ? '84.8 kWh' : '--.-- kWh',
                                      style: TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.w700,
                                        color: apiConnectionStatus
                                            ? Colors.greenAccent
                                            : Colors.redAccent,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      apiConnectionStatus
                                          ? 'Energy usage this month'
                                          : 'Server Disconnected - Tap to connect',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: (apiConnectionStatus
                                                ? Colors.greenAccent
                                                : Colors.redAccent)
                                            .withOpacity(0.8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (!apiConnectionStatus)
                                Icon(
                                  LineIcons.exclamationCircle,
                                  color: Colors.redAccent,
                                  size: 24,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Devices Header
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Connected Devices',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              '${smartDevices.length} Devices',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Devices Grid
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
                        itemCount: smartDevices.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.85,
                        ),
                        itemBuilder: (context, index) {
                          return DeviceButton(
                            icon: smartDevices[index][0],
                            name: smartDevices[index][1],
                            area: smartDevices[index][2],
                            power: smartDevices[index][3],
                            onChange: (value) => onPowerChange(value, index),
                          );
                        },
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
}