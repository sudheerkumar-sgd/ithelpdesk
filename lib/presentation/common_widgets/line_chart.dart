import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  const LineChartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final lineBarsData = [
      LineChartBarData(
          show: true,
          spots: const [
            FlSpot(0, 0),
            FlSpot(1, 1),
            FlSpot(2, 5),
            FlSpot(3, 50),
            FlSpot(4, 100),
            FlSpot(5, 10),
          ],
          isCurved: true,
          preventCurveOverShooting: true,
          barWidth: 2),
    ];
    final betweenBarsData = [
      BetweenBarsData(fromIndex: 1, toIndex: 30),
    ];
    return LineChart(
      LineChartData(
        lineBarsData: lineBarsData,
      ), // Optional
    );
  }
}
