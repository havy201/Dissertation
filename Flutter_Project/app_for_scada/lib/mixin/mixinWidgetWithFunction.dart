import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

mixin mixinNotification on StatefulWidget {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> notifyUser(
    BuildContext context,
    String text,
    TextStyle textStyle,
    Color color,
  ) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
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