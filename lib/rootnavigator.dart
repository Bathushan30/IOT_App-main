import 'package:flutter/material.dart';

//Navigation Bar package
import 'package:google_nav_bar/google_nav_bar.dart';

//Screens
import 'package:iot/screens/home.dart';
import 'package:iot/screens/controls.dart';
import 'package:iot/screens/settings.dart';

//icons
import 'package:line_icons/line_icons.dart';
import 'package:iot/utils/app_colors.dart';

class RootNavigator extends StatefulWidget {
  const RootNavigator({super.key});
  @override
  State<RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<RootNavigator> {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.black,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: GNav(
          backgroundColor: Colors.black,
          rippleColor: AppColors.primary.withOpacity(0.1),
          tabBackgroundColor: AppColors.primary.withOpacity(0.15),
          hoverColor: AppColors.surface,
          activeColor: AppColors.primary,
          color: Colors.white.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          duration: const Duration(milliseconds: 400),
          gap: 6,
          iconSize: 26,
          onTabChange: (selctedIndex) {
            setState(() {
              index = selctedIndex;
            });
          },
          selectedIndex: index,
          tabs: const [
            GButton(
              icon: LineIcons.home,
              text: "Home",
              iconSize: 24,
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            GButton(
              icon: LineIcons.podcast,
              text: "Devices",
              iconSize: 24,
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
            GButton(
              icon: LineIcons.cog,
              text: "Settings",
              iconSize: 24,
              textStyle: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        child: getSelectedWidget(index: index),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const Home();
        break;
      case 1:
        widget = const Controls();
        break;
      case 2:
        widget = const Settings();
        break;
      default:
        widget = const Controls();
        break;
    }
    return widget;
  }
}
