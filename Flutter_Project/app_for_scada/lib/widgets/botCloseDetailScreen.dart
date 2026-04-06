import 'package:flutter/material.dart';
import '../global.dart';

final double fontSize = 16;

class BotCloseDetailScreen extends StatefulWidget
    implements PreferredSizeWidget {
  final String screenName;

  const BotCloseDetailScreen({super.key, required this.screenName});

  @override
  Size get preferredSize => const Size.fromHeight(66);
  State<BotCloseDetailScreen> createState() => _BotCloseDetailScreenState();
}

class _BotCloseDetailScreenState extends State<BotCloseDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 66,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 68, vertical: 10),
        child: FilledButton(
          onPressed: () {
            Navigator.pushNamed(context, '/${widget.screenName}');
          },
          child: Text(
            'Xong',
            style: Global.fontStyleBaloo(fontSize, color: Colors.white),
          ),
          style: FilledButton.styleFrom(
            backgroundColor: Color(0xFF032B91),
            // padding: EdgeInsets.symmetric(horizontal: 138, vertical: 13),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
