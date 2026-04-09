import 'dart:convert';

class Alarm {
  DateTime time;
  String error;
  String detail;
  String status;

  Alarm({
    required this.time,
    required this.error,
    required this.detail,
    required this.status,
  });

  Map<String, dynamic> toData() {
    return {
      'time': time.toIso8601String(), //chuan hoa thoi gian yy mm dd hh:mm:ss
      'error': error,
      'detail': detail,
      'status': status,
    };
  }

  Map<String, dynamic> toMap() => toData();

  //jsonEncode la ham chuyen doi mot doi tuong Dart sang chuoi JSON
  String toJson() => jsonEncode(toData());

  //du lieu tu server la dang Map -> chuyen Map sang doi tuong Alarm
  factory Alarm.fromMap(Map<String, dynamic> data) {
    return Alarm //goi ham constructor de tao doi tuong Alarm
    (
      time: DateTime.parse(data['time']),
      error: data['error'], //error la: gia tri cua key 'error' trong Map data
      detail: data['detail'],
      status: data['status'],
    );
  }

  factory Alarm.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return Alarm(
      time: DateTime.parse(map['time']),
      error: map['error'],
      detail: map['detail'],
      status: map['status'],
    );
  }
  @override
  String toString() {
    return 'Alarm(time: $time, error: $error, detail: $detail, status: $status)';
  }
}
