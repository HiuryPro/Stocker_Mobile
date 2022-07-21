import 'package:fl_chart/fl_chart.dart' as pie;
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'dart:html' as html;

import '../Validacao_e_Gambiarra/cores.dart';

//Thanks C Scutt for the pdf code, helped a lot

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Dados> data = [];
  List<String> venda = ["Suco", "Cerveja", "Puta", "Comida"];
  List<double> preco = [10, 20, 30, 40];

  Cores cor = Cores();
  final pdf = pw.Document();
  var anchor;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < preco.length; i++) {
      data.add(Dados(venda[i], preco[i], cor.cores[i]));
    }
    createPDF();
    // Page
  }

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'pdf.pdf';
    html.document.body?.children.add(anchor);
  }

  createPDF() async {
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          children: [
            pw.Text('Hello World', style: pw.TextStyle(fontSize: 40)),
          ],
        ),
      ),
    );
    savePDF();
  }

  List<pie.PieChartSectionData> getSections() => data
      .asMap()
      .map<int, pie.PieChartSectionData>((index, data) {
        final value = pie.PieChartSectionData(
            color: data.color,
            value: data.valor,
            title: '${data.valor}',
            titleStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white));

        return MapEntry(index, value);
      })
      .values
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Center(child: Text("Funciona")),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: pie.PieChart(
              pie.PieChartData(
                // centerSpaceRadius: 0,
                borderData: pie.FlBorderData(
                  show: true,
                ),
                sections: getSections(),
              ),
            ),
          ),
          ElevatedButton(
              onPressed: () async {
                anchor.click();
                Navigator.pop(context);
              },
              child: Text("Cria pdf"))
        ],
      ),
    ));
  }
}

class Dados {
  final String venda;
  final double valor;
  final Color color;

  Dados(this.venda, this.valor, this.color);
}
