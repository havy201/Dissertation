import 'package:app_for_scada/model/Account.dart';
import 'package:flutter/material.dart';

class Global {
  static double bottomWidth = 50;
  static double spacing = 20;
  static double padding = 10;
  static double titleGap = 5;
  static Color primaryBlue = Color(0xFF032B91);
  //gia s du lieu dang nhap, sau nay se thay bang API
  // static Account? currentUser;
  static Account currentUser = Account(
    fullname: 'Đoàn Hạ Vy',
    username: 'havydoan',
    password: '122',
    role: 2,
    phone: '0978414573',
  );

  static bool isLoggedIn =
      true; // Tạm thời set true để test giao diện, sau này sẽ dựa vào API

  
  static TextStyle fontStyleBaloo(double size, {Color? color}) => TextStyle(
    fontFamily: 'Baloo',
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color ?? Color(0xFF032B91),
  );

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
  static String accountEndpoint = 'Account';
}
