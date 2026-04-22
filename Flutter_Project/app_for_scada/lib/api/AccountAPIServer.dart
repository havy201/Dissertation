import 'package:app_for_scada/model/Account.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart';

class AccountAPIServer {
  static final AccountAPIServer instance = AccountAPIServer._init();
  final String baseUrl = Global.baseUrl;
  final String endpoint = Global.accountEndpoint;
  AccountAPIServer._init();

    // Create - Thêm account mới
  Future<Account> createAccount(Account account) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {'Content-Type': 'application/json'},
      body: account.toJson(),
    );

    if (response.statusCode == 201) {
      return Account.fromJson(response.body);
    } else {
      throw Exception('Failed to create account: ${response.statusCode}');
    }
  }
}
