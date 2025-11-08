import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:iot/utils/app_colors.dart';

class DeviceButton extends StatelessWidget {
  final Widget icon;
  final String name;
  final String area;
  final bool power;
  final void Function(bool)? onChange;

  const DeviceButton({
    super.key,
    required this.icon,
    required this.name,
    required this.area,
    required this.power,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: power
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withOpacity(0.2),
                    AppColors.primary.withOpacity(0.05),
                  ],
                )
              : null,
          color: power ? null : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: power
                ? AppColors.primary.withOpacity(0.4)
                : Colors.white.withOpacity(0.1),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: power
                  ? AppColors.primary.withOpacity(0.2)
                  : Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: power ? 2 : 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with name and status
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: power
                              ? AppColors.primary
                              : Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: power ? AppColors.primary : Colors.grey.shade600,
                        boxShadow: power
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.6),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  area,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: power
                        ? AppColors.primary.withOpacity(0.7)
                        : Colors.white.withOpacity(0.5),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Icon and Switch
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    gradient: power
                        ? LinearGradient(
                            colors: AppColors.primaryGradient,
                          )
                        : null,
                    color: power ? null : Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: power
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.4),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ]
                        : null,
                  ),
                  child: IconTheme(
                    data: IconThemeData(
                      color: power ? Colors.white : Colors.white.withOpacity(0.5),
                      size: 28,
                    ),
                    child: icon,
                  ),
                ),
                Transform.scale(
                  scale: 0.9,
                  child: CupertinoSwitch(
                    value: power,
                    onChanged: onChange,
                    activeColor: AppColors.primary,
                    trackColor: Colors.white.withOpacity(0.1),
                    thumbColor: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}