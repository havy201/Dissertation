import 'dart:convert';

class Account {
  int id;
  String username;
  int password;
  bool role; // true: manager, false: employee

  Account({
    required this.id,
    required this.username,
    required this.password,
    required this.role,
  });
}
