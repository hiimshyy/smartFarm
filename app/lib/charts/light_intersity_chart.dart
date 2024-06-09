import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LightIntensityChartWidget extends StatefulWidget {
  final databaseManager;
  LightIntensityChartWidget({required this.databaseManager});
  @override
  _LightIntensityChartWidgetState createState() =>
      _LightIntensityChartWidgetState(databaseManager);
}

class _LightIntensityChartWidgetState extends State<LightIntensityChartWidget> {
  final databaseManager;
  late Timer _timer;
  late List<LinearSales> _data = [];
  bool _isDatabaseManagerAvailable =
      false; // Thêm biến để kiểm tra databaseManager

  _LightIntensityChartWidgetState(this.databaseManager);

  @override
  void initState() {
    super.initState();
    if (databaseManager != null) {
      _isDatabaseManagerAvailable =
          true; // Đánh dấu rằng databaseManager có sẵn
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        _updateDataFromDatabase();
      });
    }
  }

  @override
  void dispose() {
    if (_isDatabaseManagerAvailable) {
      _timer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isDatabaseManagerAvailable
        ? _buildChart()
        : Container(); // Trả về Container rỗng nếu databaseManager là null
  }

  Widget _buildChart() {
    return SfCartesianChart(
      primaryXAxis: const NumericAxis(
        desiredIntervals: 10,
        interval: 1,
      ),
      primaryYAxis: const NumericAxis(),
      series: <CartesianSeries>[
        LineSeries<LinearSales, int>(
          dataSource: _data,
          xValueMapper: (LinearSales sales, _) => sales.year,
          yValueMapper: (LinearSales sales, _) => sales.sales,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          emptyPointSettings: const EmptyPointSettings(
            mode: EmptyPointMode.average, // Kết nối các điểm dữ liệu với nhau
          ),
        ),
      ],
    );
  }

  void _updateDataFromDatabase() async {
    DateTime now = DateTime.now();

    if (databaseManager == null) {
      return; // Không làm gì nếu databaseManager là null
    }
    double? lightIntensity = await databaseManager.findLightIntensityValue();
    if (lightIntensity != null) {
      _data.add(LinearSales(now.minute, lightIntensity));
      if (_data.length > 20) {
        _data.removeAt(0);
      }
      setState(() {});
    }
  }
}

class LinearSales {
  final int year;
  final double sales;

  LinearSales(this.year, this.sales);
}
