import 'package:flutter/material.dart';

class Global {
  static double spacing = 20;
  static double padding = 10;
  static double titleGap = 5;
  static TextStyle fontStyleBaloo(double size, {Color? color}) => TextStyle(
    fontFamily: 'Baloo',
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color ?? Color(0xFF032B91),
  );
  static TextStyle fontStyleInter(double size, {bool isBold = false, bool isItalic = false, Color? color}) => TextStyle(
    fontFamily: 'Inter',
    fontSize: size,
    fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    fontStyle: isItalic ? FontStyle.italic : FontStyle.normal,
    color: color ?? Colors.black,
  );
  static TableCell tableCell(String text, {TextStyle? style}) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Text(text, style: style),
      ),
    );
  }
}
