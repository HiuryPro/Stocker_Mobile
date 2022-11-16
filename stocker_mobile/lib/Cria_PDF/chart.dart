import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

import '../credentials/supabase.credentials.dart';

class Chart extends StatefulWidget {
  final int? item;
  const Chart({Key? key, this.item}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<dynamic> dados = [];
  var crud = DataBaseService();
  int? teste;
  List<String> nomes = [];
  List<double> valores = [];

  Map<String, double> dataMap = {"Flutter": 2, "crud": 3};
  Map<String, String> legendLabels = {"Flutter": "Flutter"};

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var result =
          await SupaBaseCredentials.supaBaseClient.rpc('compra').execute();

      if (widget.item == 1) {
        for (var row in result.data) {
          setState(() {
            nomes.add("${row['valor']} : ${row['qtdtotal']}");
            valores.add(double.parse("${row['qtdtotal']}"));
          });
        }
        setState(() {
          dataMap = Map.fromIterables(nomes, valores);
          legendLabels = Map.fromIterables(nomes, nomes);
        });
      } else {
        for (var row in result.data) {
          setState(() {
            nomes.add("${row['valor']} : ${row['precototal']}");
            valores.add(double.parse("${row['precototal']}"));
          });
        }

        setState(() {
          dataMap = Map.fromIterables(nomes, valores);
          legendLabels = Map.fromIterables(nomes, nomes);
        });
      }
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
