import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  final dataMap = <String, double>{
    "Flutter": 5,
    "React": 3,
    "Xamarin": 2,
    "Ionic": 2,
  };

  final legendLabels = <String, String>{
    "Flutter": "Flutter legend",
    "React": "React legend",
    "Xamarin": "Xamarin legend",
    "Ionic": "Ionic legend",
  };

  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                  child: PieChart(
                dataMap: dataMap,
                legendLabels: legendLabels,
                chartValuesOptions: const ChartValuesOptions(
                    chartValueStyle: TextStyle(fontSize: 35)),
                legendOptions: const LegendOptions(
                  legendShape: BoxShape.rectangle,
                  legendTextStyle: TextStyle(fontSize: 50),
                ),
              )),
            ],
          ),
        )
      ],
    ));
  }
}
