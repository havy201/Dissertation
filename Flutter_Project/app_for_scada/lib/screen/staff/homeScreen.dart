import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';
import '../../widgets/topAppBar.dart';
import '../../global.dart';

class HomeScreen extends StatelessWidget
    with fontStyleMixin, itemDecorationMixin {
  const HomeScreen({super.key});

  static const double _fontSize = 20;
  static const double _contentFontSize = 14;

  // TODO: Thay bằng dữ liệu thực từ API/WebSocket
  static const List<({String label, Color color})> _statusItems = [
    (label: 'Idle', color: Color(0xff898989)),
    (label: 'Run', color: Color(0xff00FF0A)),
    (label: 'Abort', color: Color(0xffFF6A00)),
    (label: 'Stop', color: Color(0xffFF0000)),
    (label: 'Pause', color: Color(0xffFFF600)),
    (label: 'Hold', color: Color(0xffFFC800)),
    (label: 'Restart', color: Color(0xff00BBFF)),
    (label: 'Complete', color: Color(0xff1F7300)),
  ];

  @override
  Widget build(BuildContext context) {
    final spacing = Global.spacing;
    final titleGap = Global.titleGap;
    final padding = Global.padding;
    final bottomWidth = Global.bottomWidth;

    // TODO: Thay bằng dữ liệu thực từ API
    const bool isAuto = true;
    const bool isManu = false;
    const bool isRunning = true;
    const double processPercent = 0.7;
    const String processLabel = 'Trộn nguyên liệu';

    return Scaffold(
      appBar: const TopAppBar(title: 'BatchFeed'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: screenPadding(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chế độ hoạt động', style: fontStyleBaloo(_fontSize)),
            SizedBox(height: titleGap),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              decoration: containerDecoration(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _indicatorLight(isAuto, const Color(0xff1F7300)),
                  const SizedBox(width: 10),
                  Text(
                    'Auto',
                    style: fontStyleBaloo(
                      _contentFontSize,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(width: 90),
                  _indicatorLight(isManu, const Color(0xff1F7300)),
                  const SizedBox(width: 10),
                  Text(
                    'Manu',
                    style: fontStyleBaloo(
                      _contentFontSize,
                      color: Colors.grey[800],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),

            Text('Trạng thái hệ thống', style: fontStyleBaloo(_fontSize)),
            SizedBox(height: titleGap),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(padding),
              decoration: containerDecoration(),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,

                children: [
                  _buildStatusRow(_statusItems.sublist(0, 4), isRunning),
                  _buildStatusRow(_statusItems.sublist(4, 8), isRunning),
                ],
              ),
            ),
            SizedBox(height: spacing),

            Text('Công đoạn', style: fontStyleBaloo(_fontSize)),
            SizedBox(height: titleGap),
            Center(child: _buildProcess(processPercent, processLabel)),
          ],
        ),
      ),
    );
  }

  TableRow _buildStatusRow(
    List<({String label, Color color})> items,
    bool isRunning,
  ) {
    return TableRow(
      children: items
          .map((item) => _indicatorWithLabel(isRunning, item.color, item.label))
          .toList(),
    );
  }

  Widget _indicatorLight(bool isOn, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isOn ? color : Colors.white,
        shape: BoxShape.circle,
        border: isOn
            ? null
            : Border.all(color: const Color(0xff8C8C8C), width: 2),
      ),
    );
  }

  Widget _indicatorWithLabel(bool isOn, Color color, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Column(
          children: [
            _indicatorLight(isOn, color),
            const SizedBox(height: 4), // ✅ Sửa SizedBox width → height
            Text(
              label,
              style: fontStyleBaloo(_contentFontSize, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcess(double percent, String label) {
    return CircularPercentIndicator(
      radius: 80,
      lineWidth: 20,
      percent: percent,
      center: Text(
        '${(percent * 100).toInt()}%', // ✅ Tính từ số thay vì hardcode string
        style: fontStyleBaloo(_fontSize),
      ),
      progressColor: const Color(0xFF032B91),
      backgroundColor: const Color(0xFFC3C3C3),
      circularStrokeCap: CircularStrokeCap.round,
      footer: Text(label, style: fontStyleBaloo(_fontSize)),
    );
  }
}
