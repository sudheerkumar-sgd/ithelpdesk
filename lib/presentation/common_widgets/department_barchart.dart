import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ithelpdesk/core/constants/constants.dart';
import 'package:ithelpdesk/core/extensions/build_context_extension.dart';
import 'package:ithelpdesk/core/extensions/text_style_extension.dart';

class DepartmentBarChart extends StatelessWidget {
  final List<String> bottomLables;
  final List<double> values;

  const DepartmentBarChart({
    super.key,
    required this.bottomLables,
    required this.values,
  });

  @override
  Widget build(BuildContext context) {
    double maxY =
        values.map((d) => d).reduce((a, b) => a > b ? a : b).toDouble();
    return Stack(
      children: [
        BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: values.reduce((a, b) => a > b ? a : b).toDouble(),
            barTouchData: BarTouchData(
              enabled: false,
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
                        .onFontSize(10)
                        .onColor(Colors.white)
                        .onFontFamily(fontFamily: fontFamilyEN),
                  );
                },
              ),
              touchCallback: (event, response) {
                // setState(() {
                //   if (response == null ||
                //       response.spot == null ||
                //       !event.isInterestedForInteractions) {
                //     touchedIndex = -1;
                //     return;
                //   }
                //   touchedIndex = response.spot!.touchedBarGroupIndex;
                // });
              },
            ),
            gridData: const FlGridData(show: false),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),

              // Bottom Titles (Department Names)
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 || index >= values.length) return Container();
                    return Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Text(
                        bottomLables[index],
                        style: context.textFontWeight600
                            .onFontSize(10)
                            .onFontFamily(fontFamily: fontFamilyEN),
                      ),
                    );
                  },
                ),
              ),
            ),
            barGroups: List.generate(values.length, (i) {
              final value = values[i];

              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: value.toDouble(),
                    width: 18,
                    borderRadius: BorderRadius.zero,
                    color: const Color(0xFF7685FB),

                    // Background Bar
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: (values.reduce((a, b) => a > b ? a : b)).toDouble(),
                      color: const Color(0xFFE9ECF1),
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
        IgnorePointer(
          child: LayoutBuilder(builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: values.map((d) {
                double barHeight = 350; // chart height area

                return SizedBox(
                  width: 18,
                  height: 350,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      Positioned(
                        bottom: min(barHeight * .7,
                            max(barHeight * (d / maxY), barHeight * .2)),
                        child: Transform.rotate(
                          angle: -1.5708,
                          child: Text(
                            d.toString(),
                            style: context.textFontWeight600
                                .onFontSize(12)
                                .onColor(
                                    context.resources.color.dashboardPrimary)
                                .onFontFamily(fontFamily: fontFamilyEN),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          }),
        ),
      ],
    );
  }
}
