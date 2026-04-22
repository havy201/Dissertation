import 'dart:convert';

class Account {
  String fullname;
  String username;
  String password;
  int role; // 0: customer, 1: staff, 2: manager
  String phone;

  Account({
    required this.fullname,
    required this.username,
    required this.password,
    required this.role,
    required this.phone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': fullname,
      'username': username,
      'password': password,
      'role': role,
      'phone': phone,
    };
  }

  String toJson() => jsonEncode(toMap());

  factory Account.fromMap(Map<String, dynamic> data) {
    return Account(
      fullname: data['id'],
      username: data['username'],
      password: data['password'],
      role: data['role'],
      phone: data['phone'],
    );
  }

  factory Account.fromJson(String json) => Account.fromMap(jsonDecode(json));
}
