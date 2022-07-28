import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:stocker_mobile/Validacao_e_Gambiarra/cores.dart';

import '../DadosDB/CRUD.dart';
import '../DadosDB/crud2.dart';

class BarChart2 extends StatefulWidget {
  const BarChart2({Key? key}) : super(key: key);

  @override
  State<BarChart2> createState() => _BarChart2State();
}

class _BarChart2State extends State<BarChart2> {
  var db = CRUD2();
  var cores = Cores();
  List<OrdinalSales> data = [OrdinalSales('Teste', 10, Colors.blue)];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var result = await db.selectRT();
      int count = 0;
      data.clear();
      for (int i = 0; i < result.length; i = i + 4) {
        setState(() {
          data.add(OrdinalSales(
              '${result[i + 1]}', result[i + 3], cores.cores[count]));
          count++;
        });
      }
    });

    super.initState();
  }

  List<charts.Series<OrdinalSales, String>> _createSampleData() {
    return [
      charts.Series<OrdinalSales, String>(
        id: 'Sales',
        colorFn: (OrdinalSales sales, _) =>
            charts.ColorUtil.fromDartColor(sales.cor),
        domainFn: (OrdinalSales sales, _) => sales.year,
        measureFn: (OrdinalSales sales, _) => sales.sales,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: charts.BarChart(
            _createSampleData(),
            animate: false,
            behaviors: [
              charts.DatumLegend(
                position: charts.BehaviorPosition.bottom,
                outsideJustification: charts.OutsideJustification.endDrawArea,
                horizontalFirst: false,
                desiredMaxRows: 4,
                entryTextStyle: charts.TextStyleSpec(
                    color: charts.MaterialPalette.black,
                    fontFamily: 'Helvetica',
                    fontSize:
                        MediaQuery.of(context).size.width < 800 ? 20 : 50),
              )
            ],
            domainAxis: const charts.OrdinalAxisSpec(
                renderSpec: charts.SmallTickRendererSpec(

                    // Tick and Label styling here.
                    labelStyle: charts.TextStyleSpec(fontSize: 0),

                    // Change the line colors to match text color.
                    lineStyle: charts.LineStyleSpec(
                        color: charts.MaterialPalette.black))),

            /// Assign a custom style for the measure axis.
            primaryMeasureAxis: charts.NumericAxisSpec(
                renderSpec: charts.GridlineRendererSpec(
                    labelStyle: charts.TextStyleSpec(
                        fontSize:
                            MediaQuery.of(context).size.width < 800 ? 20 : 50,
                        color: charts.MaterialPalette.black),
                    lineStyle: const charts.LineStyleSpec(
                        color: charts.MaterialPalette.black))),
          ),
        ),
      ]),
    );
  }
}

class OrdinalSales {
  final String year;
  final double sales;
  final Color cor;

  OrdinalSales(this.year, this.sales, this.cor);
}
