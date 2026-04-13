import 'package:flutter/material.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

class TopAppBar extends StatelessWidget
    with fontStyleMixin
    implements PreferredSizeWidget {
  final String title;
  final double sizeImage = 30;
  final double buttonExtent = 56;
  const TopAppBar({super.key, required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(30);
  final double fontSize = 28;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      leadingWidth: buttonExtent,
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: fontStyleBaloo(fontSize),
      ),
      leading: IconButton(
        onPressed: () {
          print('Help icon pressed');
        },
        padding: EdgeInsets.zero,
        constraints: BoxConstraints.tightFor(
          width: buttonExtent,
          height: buttonExtent,
        ),
        highlightColor: Colors.transparent,
        icon: Image.asset(
          'lib/icons/help.png',
          width: sizeImage,
          height: sizeImage,
        ),
      ),
      actions: [
        SizedBox(
          width: buttonExtent,
          child: IconButton(
            onPressed: () {
              print('User account icon pressed');
            },
            padding: EdgeInsets.zero,
            constraints: BoxConstraints.tightFor(
              width: buttonExtent,
              height: buttonExtent,
            ),
            highlightColor: Colors.transparent,
            icon: Image.asset(
              'lib/icons/user_account.png',
              width: sizeImage,
              height: sizeImage,
            ),
          ),
        ),
      ],
    );
  }
}
