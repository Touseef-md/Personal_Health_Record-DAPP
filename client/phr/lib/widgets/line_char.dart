import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart' as fl;

class LineChart extends StatefulWidget {
  const LineChart({super.key});

  @override
  State<LineChart> createState() => _LineChartState();
}

class _LineChartState extends State<LineChart> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: fl.LineChart(
        fl.LineChartData(),
      ),
    );
    ;
    // return LineChart(
    //   LineChartData(
    //     minX: 1,
    //     maxX: 12,
    //     minY: 0,
    //     maxY: 400,
    //   ),
    // );
    // return LineChart;
  }
}
