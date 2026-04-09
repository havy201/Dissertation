import 'package:app_for_scada/model/Alarm.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../global.dart';

class AlarmAPIServer {
  static final AlarmAPIServer instance = AlarmAPIServer._init();
  final String baseUrl = Global.baseUrl;
  final String endpoint = 'alarms';

  AlarmAPIServer._init();

  Future<List<Alarm>> getAllAlarms() async {
    final response = await http.get(Uri.parse('$baseUrl/$endpoint'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Alarm.fromMap(item)).toList();
    } else {
      throw Exception('Failed to load alarms');
    }
  }
}
