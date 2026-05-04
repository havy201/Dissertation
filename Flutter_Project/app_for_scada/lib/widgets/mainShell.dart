import 'package:flutter/material.dart';
import '../global.dart';
import '../screen/staff/homeScreen.dart';
import '../screen/staff/recipeScreen.dart';
import '../screen/staff/trendScreen.dart';
import '../screen/staff/alarmScreen.dart';
import '../screen/staff/reportScreen.dart';
import '../screen/customer/orderScreen.dart';
import '../screen/customer/checkScreen.dart';

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  late final List<Widget> _staffScreens = const [
    HomeScreen(),
    RecipeScreen(),
    TrendScreen(),
    AlarmScreen(),
    ReportScreen(),
  ];

  late final List<Widget> _customerScreens = const [
    OrderScreen(),
    CheckScreen(),
  ];

  List<Widget> get _screens =>
      Global.currentUser?.role == 0 ? _customerScreens : _staffScreens;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IndexedStack(index: _currentIndex, children: _screens),
        Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNav()),
      ],
    );
  }

  Widget _buildBottomNav() {
    final isStaff =
        Global.currentUser?.role == 1 || Global.currentUser?.role == 2;

    return Container(
      height: Global.bottomWidth,
      decoration: const BoxDecoration(color: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: isStaff ? _staffNavItems() : _customerNavItems(),
      ),
    );
  }

  List<Widget> _staffNavItems() => [
    _navItem('lib/icons/home_dark.png', 'lib/icons/home_light.png', 0),
    _navItem('lib/icons/recipe_dark.png', 'lib/icons/recipe_light.png', 1),
    _navItem('lib/icons/trend_dark.png', 'lib/icons/trend_light.png', 2),
    _navItem('lib/icons/alarm_dark.png', 'lib/icons/alarm_light.png', 3),
    _navItem('lib/icons/report_dark.png', 'lib/icons/report_light.png', 4),
  ];

  List<Widget> _customerNavItems() => [
    _navItem('lib/icons/home_dark.png', 'lib/icons/home_light.png', 0),
    _navItem('lib/icons/recipe_dark.png', 'lib/icons/recipe_light.png', 1),
  ];

  Widget _navItem(String iconActive, String iconInactive, int index) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) {
          setState(() => _currentIndex = index);
        }
      },
      child: Image.asset(isSelected ? iconActive : iconInactive, height: 30),
    );
  }
}
