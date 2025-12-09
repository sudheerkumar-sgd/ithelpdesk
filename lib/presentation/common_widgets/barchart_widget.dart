import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

class BarchartWidget extends StatefulWidget {
  final List<String> bottomLables;
  final List<double> values;
  const BarchartWidget(
      {required this.bottomLables, required this.values, super.key});

  @override
  State<BarchartWidget> createState() => _BarchartWidgetState();
}

class _BarchartWidgetState extends State<BarchartWidget> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    final maxY = widget.values.reduce((a, b) => a > b ? a : b) + 1;
    return SizedBox(
      height: 220,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          alignment: BarChartAlignment.spaceAround,
          barTouchData: BarTouchData(
            enabled: true,
            handleBuiltInTouches: true,
            touchTooltipData: BarTouchTooltipData(
              // <-- updated property
              tooltipPadding: const EdgeInsets.all(5),
              tooltipMargin: 8,
              getTooltipColor: (group) {
                return context.resources.color.dashboardSecondary;
              },
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                return BarTooltipItem(
                  '${rod.toY}',
                  context.textFontWeight600
                      .onFontSize(12)
                      .onColor(Colors.white)
                      .onFontFamily(fontFamily: fontFamilyEN),
                );
              },
            ),
            touchCallback: (event, response) {
              setState(() {
                if (response == null ||
                    response.spot == null ||
                    !event.isInterestedForInteractions) {
                  touchedIndex = -1;
                  return;
                }
                touchedIndex = response.spot!.touchedBarGroupIndex;
              });
            },
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: ((maxY / 5).ceilToDouble()),
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey.withAlpha((0.3 * 255).toInt()),
              dashArray: [5, 5],
            ),
          ),
          borderData: FlBorderData(show: false),
          titlesData: FlTitlesData(
            leftTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: bottomTitles,
              ),
            ),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          barGroups: _barGroups(),
        ),
      ),
    );
  }

  List<BarChartGroupData> _barGroups() {
    return List.generate(widget.values.length, (index) {
      final bool isSelected = index == touchedIndex;

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: widget.values[index],
            width: 26,
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18), topRight: Radius.circular(18)),
            color: isSelected
                ? const Color(0xFF1E40FF) // active hover color
                : const Color(0xFF3763FF).withAlpha((0.2 * 255).toInt()),
          ),
        ],
      );
    });
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        textDirection: TextDirection.ltr,
        widget.bottomLables[value.toInt()],
        style: context.textFontWeight600
            .onFontSize(
              context.resources.fontSize.dp10,
            )
            .onFontFamily(fontFamily: fontFamilyEN),
      ),
    );
  }
}
