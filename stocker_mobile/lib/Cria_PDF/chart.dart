import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

import '../credentials/supabase.credentials.dart';

class Chart extends StatefulWidget {
  final int? item;
  final int? opcao;
  final String? data1;
  final String? data2;
  const Chart({Key? key, this.item, this.opcao, this.data1, this.data2})
      : super(key: key);

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
      dataMap.clear();
      legendLabels.clear();
      nomes.clear();
      valores.clear();

      if (widget.opcao == 1) {
        var result = await SupaBaseCredentials.supaBaseClient.rpc('compra',
            params: {'data1': widget.data1, 'data2': widget.data2}).execute();

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
              nomes.add(
                  "${row['valor']} : ${row['precototal'].toStringAsFixed(2)}");
              valores
                  .add(double.parse("${row['precototal'].toStringAsFixed(2)}"));
            });
          }

          setState(() {
            dataMap = Map.fromIterables(nomes, valores);
            legendLabels = Map.fromIterables(nomes, nomes);
          });
        }
      } else {
        var qtdTotalVenda = await SupaBaseCredentials.supaBaseClient.rpc(
            'qtdvenda',
            params: {'data1': widget.data1, 'data2': widget.data2}).execute();

        if (widget.item == 1) {
          for (var row in qtdTotalVenda.data) {
            setState(() {
              nomes.add("${row['nomep']} : ${row['qtdtotal']}");
              valores.add(double.parse("${row['qtdtotal']}"));
            });
          }
          setState(() {
            dataMap = Map.fromIterables(nomes, valores);
            legendLabels = Map.fromIterables(nomes, nomes);
          });
        } else {
          for (var row in qtdTotalVenda.data) {
            setState(() {
              nomes
                  .add("${row['nomep']} : ${row['totalv'].toStringAsFixed(2)}");
              valores.add(double.parse("${row['totalv'].toStringAsFixed(2)}"));
            });
          }

          setState(() {
            dataMap = Map.fromIterables(nomes, valores);
            legendLabels = Map.fromIterables(nomes, nomes);
          });
        }
      }
    });

    super.initState();
  }

  double retornaTotal(int qtd, double prec, double adic, double desc) {
    double preTotal = (qtd * prec);
    double preTotalComAdicional = preTotal + (preTotal * (adic / 100));
    double total = preTotalComAdicional - (preTotalComAdicional * (desc / 100));

    return total;
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
              decimalPlaces: 2,
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
