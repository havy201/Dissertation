import 'package:flutter/material.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

class TitleAppBar extends StatelessWidget
    with fontStyleMixin
    implements PreferredSizeWidget {
  final String title;
  final bool isReload;
  final double sizeImage = 30;
  final double buttonExtent = 56;

  const TitleAppBar({super.key, required this.title, this.isReload = false});

  @override
  Size get preferredSize => const Size.fromHeight(40);
  final double fontSize = 28;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      centerTitle: true,
      leadingWidth: buttonExtent,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: fontStyleBaloo(fontSize),
      ),
      actions: [
        SizedBox(
          width: buttonExtent,
          child: IconButton(
            onPressed: () => Navigator.pop(context, isReload),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(
              width: buttonExtent,
              height: buttonExtent,
            ),
            highlightColor: Colors.transparent,
            icon: Icon(Icons.close, size: sizeImage, color: Color(0xFF032B91)),
          ),
        ),
      ],
    );
  }
}
