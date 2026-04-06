import 'package:flutter/material.dart';
import '../widgets/botNavigation.dart';
import '../widgets/topAppBar.dart';

class TrendScreen extends StatelessWidget {
  const TrendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Biểu đồ'),
      backgroundColor: Colors.white,
      bottomNavigationBar: const BotNavigation(currentIndex: 2),
    );
  }
}
