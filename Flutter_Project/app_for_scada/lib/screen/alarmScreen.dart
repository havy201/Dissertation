import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import 'package:app_for_scada/widgets/botNavigation.dart';
import 'package:app_for_scada/widgets/topAppBar.dart';
import '../model/Alarm.dart';
import '../api/AlarmAPIServer.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double padding = Global.spacing;
final double fontSize = 12;
final double fontTitleSize = 16;

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen>
    with fontStyleMixin, itemDecorationMixin {
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
            _row(
              'Thời gian',
              'Lỗi',
              'Chi tiết',
              'Trạng thái',
              style: fontStyleBaloo(fontTitleSize),
              decoration: const BoxDecoration(color: Color(0xFFE0E0E0)),
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

  TableRow _row(
    String time,
    String error,
    String detail,
    String status, {
    TextStyle? style,
    Decoration? decoration,
  }) {
    return TableRow(
      decoration: decoration,
      children: [
        tableCell(time, style: style),
        tableCell(error, style: style),
        tableCell(detail, style: style),
        tableCell(status, style: style),
      ],
    );
  }
}
