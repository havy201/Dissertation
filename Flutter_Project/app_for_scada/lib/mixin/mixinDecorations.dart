import 'package:flutter/material.dart';

mixin InputFieldDecorationMixin {
  Padding prefixIconPadding(String assetPath) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Image.asset(assetPath, width: 35, height: 35),
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

  BoxDecoration containerDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Color(0xff8C8C8C), width: 3),
    );
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
