import 'dart:convert';
import 'Account.dart';

class Authresponse {
  Account? account;
  bool passWordTrue;
  String? message;
  Authresponse({
    this.account,
    required this.passWordTrue,
    this.message,
  });

factory Authresponse.fromMap(Map<String, dynamic> data) {
    return Authresponse(
      account: data['account'] != null ? Account.fromMap(data['account']) : null,
      passWordTrue: data['passWordTrue'] as bool,
      message: data['message'] as String?,
    );
  }
  factory Authresponse.fromJson(String json) => Authresponse.fromMap(jsonDecode(json));
}
