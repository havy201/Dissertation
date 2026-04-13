import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import '../widgets/botNavigation.dart';
import '../widgets/topAppBar.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

final double itemSpacing = Global.spacing;
final double titleGap = Global.titleGap;
final double padding = Global.padding;
final double fontSize = 20;
final double contentFontSize = 14;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with fontStyleMixin, itemDecorationMixin {
  bool isRunning = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'BatchFeed'),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(itemSpacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Chế độ hoạt động', style: fontStyleBaloo(fontSize)),
              SizedBox(height: titleGap),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding),
                decoration: containerDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    indicatorLight(
                      isRunning,
                      Color(0xff1F7300), //đèn báo),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Auto',
                      style: fontStyleBaloo(
                        contentFontSize,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(width: 90),
                    indicatorLight(
                      isRunning,
                      Color(0xff1F7300), //đèn báo),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Manu',
                      style: fontStyleBaloo(
                        contentFontSize,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: itemSpacing),
              Text('Trạng thái hệ thống', style: fontStyleBaloo(fontSize)),
              SizedBox(height: titleGap),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding),
                decoration: containerDecoration(),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        indicatorWithLabel(true, Color(0xff898989), 'Idle'),
                        indicatorWithLabel(true, Color(0xff00FF0A), 'Run'),
                        indicatorWithLabel(true, Color(0xffFF6A00), 'Abort'),
                        indicatorWithLabel(true, Color(0xffFF0000), 'Stop'),
                      ],
                    ),
                    TableRow(
                      children: [
                        indicatorWithLabel(true, Color(0xffFFF600), 'Pause'),
                        indicatorWithLabel(true, Color(0xffFFC800), 'Hold'),
                        indicatorWithLabel(true, Color(0xff00BBFF), 'Restart'),
                        indicatorWithLabel(true, Color(0xff1F7300), 'Complete'),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: itemSpacing),
              Text('Công đoạn', style: fontStyleBaloo(fontSize)),
              SizedBox(height: titleGap),
              Center(child: process('70%', 'Trộn nguyên liệu')),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BotNavigation(currentIndex: 0),
    );
  }

  Container indicatorLight(bool isOn, Color color) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: isOn ? color : Colors.white,
        shape: BoxShape.circle,
        border: isOn ? null : Border.all(color: Color(0xff8C8C8C), width: 2),
      ),
    );
  }

  CircularPercentIndicator process(String percent, String footer) {
    return CircularPercentIndicator(
      radius: 80,
      lineWidth: 20,
      percent: 0.7,
      center: Text(percent, style: Global.fontStyleBaloo(fontSize)),
      progressColor: Color(0xFF032B91),
      backgroundColor: Color(0xFFC3C3C3),
      circularStrokeCap: CircularStrokeCap.round,
      footer: Text(footer, style: Global.fontStyleBaloo(fontSize)),
    );
  }

  Padding indicatorWithLabel(bool isRun, Color color, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Column(
          children: [
            indicatorLight(isRun, color),
            SizedBox(width: 10),
            Text(
              label,
              style: fontStyleBaloo(contentFontSize, color: Colors.grey[800]),
            ),
          ],
        ),
      ),
    );
  }
}
