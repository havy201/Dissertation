import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/botNavigation.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import '../model/Alarm.dart';
import '../api/AlarmAPIServer.dart';

final double padding = Global.spacing;
final double fontSize = 12;
final double fontTitleSize = 16;

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {
  late Future<List<Alarm>> _alarmsFuture;
  @override
  void initState() {
    super.initState();
    _alarmsFuture = AlarmAPIServer.instance.getAllAlarms();
  }

  Future<void> _refreshAlarms() async {
    setState(() {
      _alarmsFuture = AlarmAPIServer.instance.getAllAlarms();
      ;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Cảnh báo'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.all(padding),
        child: Table(
          border: TableBorder.all(color: Colors.grey),
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          children: [
            TableRow(
              decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
              children: [
                Global.tableCell(
                  'Thời gian',
                  style: Global.fontStyleBaloo(fontTitleSize),
                ),
                Global.tableCell(
                  'Lỗi',
                  style: Global.fontStyleBaloo(fontTitleSize),
                ),
                Global.tableCell(
                  'Chi tiết',
                  style: Global.fontStyleBaloo(fontTitleSize),
                ),
                Global.tableCell(
                  'Trạng thái',
                  style: Global.fontStyleBaloo(fontTitleSize),
                ),
              ],
            ),
            _row(
              '16:50:23 27/3/2026',
              'System alarm',
              'Kẹt máy bơm',
              'Chưa sửa lỗi',
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BotNavigation(currentIndex: 3),
    );
  }
}

TableRow _row(
  String time,
  String error,
  String detail,
  String status, {
  TextStyle? style,
}) {
  return TableRow(
    children: [
      Global.tableCell(time, style: style),
      Global.tableCell(error, style: style),
      Global.tableCell(detail, style: style),
      Global.tableCell(status, style: style),
    ],
  );
}
