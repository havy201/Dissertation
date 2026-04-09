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
  static TextStyle fontStyleInter(
    double size, {
    bool isBold = false,
    bool isItalic = false,
    Color? color,
  }) => TextStyle(
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

  static Center loadingIndicator() {
    return Center(
      child: SizedBox(
        width: 50,
        height: 50,
        child: CircularProgressIndicator(
          strokeWidth: 10,
          strokeCap: StrokeCap.round,
          color: Color(0xFF032B91),
          backgroundColor: Colors.grey[200],
        ),
      ),
    );
  }

  static SingleChildScrollView errorIndicator(
    String message,
    BuildContext context,
  ) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Container(
        height:
            MediaQuery.of(context).size.height * 0.7, // Tạo chiều cao đủ để kéo
        alignment: Alignment.center,
        child: Text(message, style: Global.fontStyleBaloo(20)),
      ),
    );
  }

  static String baseUrl = 'https://68944fbebe3700414e12a830.mockapi.io/school';
  static String recipeEndpoint = 'Recipe';
}
