import 'package:app_for_scada/model/Login/Account.dart';
import 'package:app_for_scada/model/Login/AuthResponse.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart';

class LoginAPIServer {
  static final LoginAPIServer instance = LoginAPIServer._init();
  final String baseUrl = Global.baseUrl;
  final String endpoint = Global.loginEndpoint;
  LoginAPIServer._init();

  // tao account moi
  Future<bool> createAccount(Account account) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint/create'),
      headers: {'Content-Type': 'application/json'},
      body: account.toJson(),
    );

    if (response.statusCode == 200 ||
        response.statusCode == 201 ||
        response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to create account: ${response.statusCode}');
    }
  }

  // cap nhạt thong tin
  Future<bool> updateUser(Account account) async {
    final response = await http.patch(
      Uri.parse('$baseUrl/$endpoint/update'),
      headers: {'Content-Type': 'application/json'},
      body: account.toJson(),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to patch user: ${response.statusCode}');
    }
  }

  //xoa nguoi dung
  Future<bool> deleteUser(String userName) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/$endpoint/delete?userName=$userName'),
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return true;
    } else {
      throw Exception('Failed to delete user: ${response.statusCode}');
    }
  }

  // dang nhap
  Future<Authresponse> login(String userName, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint/AuthenticateUser'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'userName': userName, 'password': password}),
    );

    if (response.statusCode == 200) {
      return Authresponse.fromJson(response.body);
    } else {
      throw Exception('Failed to authenticate: ${response.statusCode}');
    }
  }
}
