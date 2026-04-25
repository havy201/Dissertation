import 'package:app_for_scada/model/Trend.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../widgets/topAppBar.dart';
import 'package:app_for_scada/mixin/mixinDecorations.dart';

class TrendScreen extends StatefulWidget {
  const TrendScreen({super.key});

  @override
  State<TrendScreen> createState() => _TrendScreenState();
}

class _TrendScreenState extends State<TrendScreen> with itemDecorationMixin {
  List<FlSpot> spots = [FlSpot(10, 11), FlSpot(20, 21), FlSpot(30, 15)];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(title: 'Biểu đồ'),
      backgroundColor: Colors.white,

      body: Padding(
        padding: screenPadding(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 300, child: LineChart(lineChartData())),
            // SizedBox(
            //   height: 300,
            //   width: 300,
            //   child: Card(child: LineChart(lineChartData())),
            // ),
          ],
        ),
      ),
    );
  }

  List<FlSpot> constantFromData(List<Trend> data, double yValue) {
    return data.map((e) => FlSpot(e.time, yValue)).toList();
  }

  LineChartData lineChartData() {
    return LineChartData(
      minY: 0,
      maxY: 300,
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: true),
          axisNameWidget: Text('Giá trị'),
        ),
      ),
      lineBarsData: [
        LineChartBarData(
          spots: trends.map((e) => FlSpot(e.time, e.value)).toList(),
          isCurved: true,
          barWidth: 2,
          dotData: FlDotData(show: false),
        ),
        LineChartBarData(
          spots: constantFromData(trends, 100),
          isCurved: false,
          color: Colors.red,
          barWidth: 2,
          dotData: FlDotData(show: false),
        ),
      ],
    );
  }
}
