import 'package:flutter/material.dart';
import '../../widgets/topAppBar.dart';
class CheckScreen extends StatefulWidget {
  const CheckScreen({super.key});

  @override
  State<CheckScreen> createState() => _CheckScreenState();
}

class _CheckScreenState extends State<CheckScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TopAppBar(title: 'Theo dõi đơn hàng'),
      backgroundColor: Colors.white,
      body: Column(),
  
    );
  }
}
