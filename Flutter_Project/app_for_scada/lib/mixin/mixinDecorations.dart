import 'package:flutter/material.dart';
import '../global.dart';

final spacing = Global.spacing;
final bottomWidth = Global.bottomWidth;
mixin InputFieldDecorationMixin {
  Padding prefixIconPadding(String assetPath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Image.asset(
        assetPath,
        width: 35,
        height: 35,
        color: Color(0xFF032B91),
      ),
    );
  }

  EdgeInsets contentPadding() {
    return EdgeInsets.only(left: 21, right: 12, top: 20, bottom: 20);
  }

  OutlineInputBorder outlineInputBorder() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: Color(0xFF032B91), width: 2),
    );
  }

  Padding suffixIconPadding(bool obscurePassword, Function() toggleObscure) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: GestureDetector(
        onTap: toggleObscure,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Image.asset(
            obscurePassword
                ? 'lib/icons/hidePassword.png'
                : 'lib/icons/showPassword.png',
            width: 35,
            height: 35,
          ),
        ),
      ),
    );
  }
}

mixin itemDecorationMixin {
  TableCell tableCell(String text, {TextStyle? style}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(text, style: style),
      ),
    );
  }

  BoxDecoration containerDecoration({Color? color}) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: color ?? Color(0xff8C8C8C), width: 3),
    );
  }

  FloatingActionButton floatingBtn(VoidCallback? onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFF032B91), width: 4),
      ),
      backgroundColor: Colors.white,
      child: Icon(Icons.add, size: 40, color: Color(0xFF032B91)),
    );
  }

  Widget iconBtnCustom(VoidCallback? onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFF032B91), width: 4),
      ),
      elevation: 0,

      backgroundColor: Colors.white,
      child: Icon(Icons.add, size: 40, color: Color(0xFF032B91)),
    );
  }

  SizedBox filledBtn(VoidCallback? onPressed, String text, {Color? color}) {
    return SizedBox(
      width: 276,
      height: 46,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF032B91),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Baloo',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  EdgeInsets screenPadding() {
    final spacing = Global.spacing;
    return EdgeInsets.all(spacing);
  }
}
mixin fontStyleMixin {
  TextStyle fontStyleBaloo(double size, {Color? color}) {
    return TextStyle(
      fontFamily: 'Baloo',
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: color ?? Color(0xFF032B91),
    );
  }

  TextStyle fontStyleInter(
    double size, {
    bool isBold = false,
    bool isItalic = false,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: 'Inter',
      fontSize: size,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
      color: color ?? Colors.black,
    );
  }
}
