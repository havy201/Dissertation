import 'package:app_for_scada/global.dart';
import 'package:flutter/material.dart';
import '../widgets/botNavigation.dart';
import '../widgets/topAppBar.dart';
import 'package:percent_indicator/percent_indicator.dart';

final double itemSpacing = Global.spacing;
final double titleGap = Global.titleGap;
final double padding = Global.padding;
final double fontSize = 20;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              Text('Chế độ hoạt động', style: Global.fontStyleBaloo(fontSize)),
              SizedBox(height: titleGap),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding),
                decoration: Decorations().containerDecoration(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Decorations().indicatorLight(
                      isRunning,
                      Color(0xff1F7300), //đèn báo),
                    ),
                    SizedBox(width: 10),
                    Text('Auto', style: Decorations().contentStyle),
                    SizedBox(width: 90),
                    Decorations().indicatorLight(
                      isRunning,
                      Color(0xff1F7300), //đèn báo),
                    ),
                    SizedBox(width: 10),
                    Text('Manu', style: Decorations().contentStyle),
                  ],
                ),
              ),
              SizedBox(height: itemSpacing),
              Text(
                'Trạng thái hệ thống',
                style: Global.fontStyleBaloo(fontSize),
              ),
              SizedBox(height: titleGap),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(padding),
                decoration: Decorations().containerDecoration(),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  children: [
                    TableRow(
                      children: [
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xff898989),
                          'Idle',
                        ),
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xff00FF0A),
                          'Run',
                        ),
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xffFF6A00),
                          'Abort',
                        ),
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xffFF0000),
                          'Stop',
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xffFFF600),
                          'Pause',
                        ),
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xffFFC800),
                          'Hold',
                        ),
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xff00BBFF),
                          'Restart',
                        ),
                        Decorations().indicatorWithLabel(
                          true,
                          Color(0xff1F7300),
                          'Complete',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: itemSpacing),
              Text('Công đoạn', style: Global.fontStyleBaloo(fontSize)),
              SizedBox(height: titleGap),
              Center(child: Decorations().process('70%', 'Trộn nguyên liệu')),
            ],
          ),
        ),
      ),

      bottomNavigationBar: const BotNavigation(currentIndex: 0),
    );
  }
}

class Decorations {
  TextStyle get contentStyle =>
      TextStyle(fontFamily: 'Baloo', fontSize: 14, color: Colors.grey[800]);

  BoxDecoration containerDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Color(0xff8C8C8C), width: 3),
  );

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

  Padding indicatorWithLabel(bool isOn, Color color, String label) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Center(
        child: Column(
          children: [
            indicatorLight(isOn, color),
            SizedBox(width: 10),
            Text(label, style: contentStyle),
          ],
        ),
      ),
    );
  }
}
