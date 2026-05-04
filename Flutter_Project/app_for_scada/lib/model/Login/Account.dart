import 'dart:convert';

class Account {
  String userName;
  String? fullName;
  String? password;
  int? role; // 0: customer, 1: staff, 2: manager
  String? phoneNumber;
  // Các field phụ dùng để gửi Request (Create/Update)
  String? oldPassword;
  String? newPassword;
  int? staffCode;
  Account({
    required this.userName,
    this.fullName,
    this.password,
    this.role,
    this.phoneNumber,
    this.oldPassword,
    this.newPassword,
    this.staffCode,
  });

  //soan du lieu gui len server dang json, nen can ham nay de chuyen tu Account sang json
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userName'] = userName;
    if (fullName != null) data['fullName'] = fullName;
    if (password != null) data['password'] = password;
    if (role != null) data['role'] = role;
    if (phoneNumber != null) data['phoneNumber'] = phoneNumber;
    if (oldPassword != null) data['oldPassword'] = oldPassword;
    if (newPassword != null) data['newPassword'] = newPassword;
    if (staffCode != null) data['staffCode'] = staffCode;
    return data;
  }

  String toJson() => jsonEncode(toMap());

  factory Account.fromMap(Map<String, dynamic> data) {
    return Account(
      userName: data['userName'] as String,
      fullName: data['fullName'] as String?,
      password: data['password'] as String?,
      role: data['role'] as int?,
      phoneNumber: data['phoneNumber'] as String?,
      oldPassword: data['oldPassword'] as String?,
      newPassword: data['newPassword'] as String?,
      staffCode: data['staffCode'] as int?,
    );
  }
  //Nhan du lieu tu server ve dang json, nen can ham nay de chuyen tu json sang Account
  factory Account.fromJson(String json) => Account.fromMap(jsonDecode(json));
}
