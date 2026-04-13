import 'package:flutter/material.dart';

import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double fontSize = 16;

class BotCloseDetailScreen extends StatefulWidget
    implements PreferredSizeWidget {
  final String screenName;

  const BotCloseDetailScreen({super.key, required this.screenName});

  @override
  Size get preferredSize => const Size.fromHeight(50);
  State<BotCloseDetailScreen> createState() => _BotCloseDetailScreenState();
}

class _BotCloseDetailScreenState extends State<BotCloseDetailScreen> 
    with SingleTickerProviderStateMixin, fontStyleMixin {
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
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(color: Colors.white),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: 270,
          height: 40,
          child: FilledButton(
            onPressed: () {
              Navigator.pushNamed(context, '/${widget.screenName}');
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF032B91),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Xong',
              style: fontStyleBaloo(fontSize, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
