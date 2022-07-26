import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../DadosDB/crud2.dart';

class Chart2 extends StatefulWidget {
  const Chart2({Key? key}) : super(key: key);

  @override
  State<Chart2> createState() => _Chart2State();
}

class _Chart2State extends State<Chart2> {
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
          nomes.add("${result[i + 1]} : ${result[i + 3]}");
          valores.add(result[i + 3]);
        });
      }
      setState(() {
        dataMap = Map.fromIterables(nomes, valores);
        legendLabels = Map.fromIterables(nomes, nomes);
      });
    });

    super.initState();
  }

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
          ),
        )
      ],
    ));
  }
}
