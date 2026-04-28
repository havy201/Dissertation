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

class _TrendScreenState extends State<TrendScreen>
    with itemDecorationMixin, fontStyleMixin {
  List<FlSpot> spots = [FlSpot(10, 11), FlSpot(20, 21), FlSpot(30, 15)];
  @override
  Widget build(BuildContext context) {
    final double fontSize = 16.0;
    return Scaffold(
      appBar: const TopAppBar(title: 'Biểu đồ'),
      backgroundColor: Colors.white,
      body: Padding(
        padding: screenPadding(),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Biểu đồ xu hướng', style: fontStyleBaloo(fontSize)),
              AspectRatio(aspectRatio: 1.6, child: LineChart(lineChartData())),
              // SizedBox(
              //   height: 300,
              //   width: 300,
              //   child: Card(child: LineChart(lineChartData())),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  List<FlSpot> constantFromData(List<Trend> data, double yValue) {
    return data.map((e) => FlSpot(e.time, yValue)).toList();
  }

  LineChartData lineChartData() {
    return LineChartData(
      backgroundColor: Colors.black,
      minY: 0,
      maxY: 300,
      borderData: FlBorderData(
        show: true,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 1), // Kẻ vạch trục X
          left: BorderSide(color: Colors.grey, width: 1), // Kẻ vạch trục Y
          right: BorderSide.none,
          top: BorderSide.none,
        ),
      ),
      titlesData: FlTitlesData(
        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            interval: 50,
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
          ),
        ),
      ),
      lineTouchData: LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              if (spot.barIndex != 0) {
                return null; // 👈 vẫn giữ size, nhưng không hiển thị
              }

              return LineTooltipItem(
                '${spot.x}: ${spot.y}', // 👈 giá trị hiển thị
                const TextStyle(color: Colors.white),
              );
            }).toList();
          },
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
