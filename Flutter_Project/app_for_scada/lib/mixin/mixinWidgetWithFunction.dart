import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../global.dart';

mixin mixinNotification on StatefulWidget {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> notifyUser(
    BuildContext context,
    String text,
    TextStyle textStyle,
    Color color,
  ) {
    final double _spacing = Global.spacing;
    final double _bottomWidth = Global.bottomWidth;
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: EdgeInsets.only(bottom: _spacing + _bottomWidth, left: _spacing, right: _spacing),
        duration: const Duration(milliseconds: 3000),
        content: AnimatedTextKit(
          animatedTexts: [
            WavyAnimatedText(
              text,
              textStyle: textStyle,
              speed: const Duration(milliseconds: 100),
              textAlign: TextAlign.center,
            ),
          ],
          totalRepeatCount: 1,
        ),

        behavior: SnackBarBehavior.floating,
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
