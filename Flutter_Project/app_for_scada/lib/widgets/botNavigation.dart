import '../screen/staff/homeScreen.dart';
import '../screen/staff/recipeScreen.dart';
import '../screen/staff/trendScreen.dart';
import '../screen/staff/alarmScreen.dart';
import '../screen/staff/reportScreen.dart';
import '../screen/customer/orderScreen.dart';
import '../screen/customer/checkScreen.dart';
import '../screen/loginScreen.dart';
import 'package:flutter/material.dart';
import '../global.dart';

class BotNavigation extends StatelessWidget implements PreferredSizeWidget {
  final int currentIndex;
  //final int role; // 0: staff, 1: customer
  const BotNavigation({super.key, required this.currentIndex});

  @override
  Size get preferredSize => const Size.fromHeight(50);

  void _navigate(BuildContext context, int index) {
    Widget screen;
    if (index == currentIndex) return;

    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const RecipeScreen();
        break;
      case 2:
        screen = const TrendScreen();
        break;
      case 3:
        screen = const AlarmScreen();
        break;
      case 4:
        screen = const ReportScreen();
        break;
      case 5:
        screen = const OrderScreen();
        break;
      case 6:
        screen = const CheckScreen();
        break;
      default:
        screen = const LoginScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _getNavItems(context),
      ),
    );
  }

  List<Widget> _getNavItems(BuildContext context) {
    if (Global.currentUser.role == 1 || Global.currentUser.role == 2) {
      return [
        _buildNavItem(
          context,
          'lib/icons/home_dark.png',
          'lib/icons/home_light.png',
          0,
        ),
        _buildNavItem(
          context,
          'lib/icons/recipe_dark.png',
          'lib/icons/recipe_light.png',
          1,
        ),
        _buildNavItem(
          context,
          'lib/icons/trend_dark.png',
          'lib/icons/trend_light.png',
          2,
        ),
        _buildNavItem(
          context,
          'lib/icons/alarm_dark.png',
          'lib/icons/alarm_light.png',
          3,
        ),
        _buildNavItem(
          context,
          'lib/icons/report_dark.png',
          'lib/icons/report_light.png',
          4,
        ),
      ];
    } else if (Global.currentUser.role == 0) {
      return [
        _buildNavItem(
          context,
          'lib/icons/home_dark.png',
          'lib/icons/home_light.png',
          5,
        ),
        _buildNavItem(
          context,
          'lib/icons/recipe_dark.png',
          'lib/icons/recipe_light.png',
          6,
        ),
      ];
    } else
      return [];
  }

  Widget _buildNavItem(
    BuildContext context,
    String icon1,
    String icon2,
    int index,
  ) {
    final bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => _navigate(context, index),
      child: Image.asset(isSelected ? icon1 : icon2, height: 30),
    );
  }
}
