import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../DadosDB/crud.dart';

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<dynamic> dados = [];
  var teste = CRUD();
  List<String> nomes = [];
  List<double> valores = [];

  Map<String, double> dataMap = {"Flutter": 2, "Teste": 3};
  Map<String, String> legendLabels = {"Flutter": "Flutter", "Teste": "Teste"};

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var result = await teste.select("SELECT *  FROM relatoriototal ");

      for (var row in result) {
        setState(() {
          nomes.add("${row['nome_produto']} : ${row['qtd_total']}");
          valores.add(double.parse("${row['qtd_total']}"));
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
