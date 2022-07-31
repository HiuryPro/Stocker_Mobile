import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../DadosDB/crud2.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<dynamic> dados = [];
  var teste = CRUD2();
  List<String> nomes = [];
  List<double> valores = [];

  Map<String, double> dataMap = {"Flutter": 2, "Teste": 3};
  Map<String, String> legendLabels = {"Flutter": "Flutter", "Teste": "Teste"};

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var result = await teste.selectRT();

      for (int i = 0; i < result.length; i = i + 4) {
        setState(() {
          nomes.add("${result[i + 1]} : ${result[i + 2]}");
          valores.add(double.parse('${result[i + 2]}'));
        });
      }
      setState(() {
        dataMap = Map.fromIterables(nomes, valores);
        legendLabels = Map.fromIterables(nomes, nomes);
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Expanded(
            child: PieChart(
          dataMap: dataMap,
          animationDuration: const Duration(seconds: 0),
          legendLabels: legendLabels,
          chartValuesOptions: const ChartValuesOptions(
              showChartValueBackground: false,
              decimalPlaces: 0,
              chartValueStyle: TextStyle(fontSize: 35)),
          legendOptions: const LegendOptions(
              legendShape: BoxShape.rectangle,
              legendTextStyle: TextStyle(fontSize: 34),
              legendPosition: LegendPosition.bottom),
        )),
      ],
    ));
  }
}
