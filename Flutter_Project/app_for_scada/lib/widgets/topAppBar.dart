import 'package:flutter/material.dart';
import 'package:app_for_scada/mixin/mixins.dart';

class TopAppBar extends StatelessWidget
    with mixinDecoration
    implements PreferredSizeWidget {
  final String title;
  final double sizeImage = 30;
  final double buttonExtent = 56;
  const TopAppBar({super.key, required this.title});
  @override
  Size get preferredSize => const Size.fromHeight(40);
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
          Navigator.pushNamed(context, '/helpScreen');
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
              Navigator.pushNamed(context, '/infoUser');
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
