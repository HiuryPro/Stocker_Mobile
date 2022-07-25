import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'package:pie_chart/pie_chart.dart';
import '../Cria_PDF/chart.dart';
import '../Cria_PDF/chart2.dart';
import '../DadosDB/CRUD.dart';
import '../DadosDB/crud2.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/cores.dart';

class Chart3 extends StatefulWidget {
  const Chart3({Key? key}) : super(key: key);

  @override
  State<Chart3> createState() => _Chart3State();
}

class _Chart3State extends State<Chart3> {
  List<dynamic> dados = [];
  var teste = CRUD2();
  List<String> nomes = [];
  List<double> valores = [];

  Map<String, double> dataMap = {"data": 2};
  Map<String, String> legendLabels = {"data": "data"};

  final pdf = pw.Document();
  var anchor;
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

  savePDF() async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'relatorio.pdf';
    html.document.body?.children.add(anchor);
  }

  createPDF(var by) async {
    pdf.addPage(pw.MultiPage(
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (context) => [
              pw.Center(
                  child: pw.Text("Gráfico de quantidade de produtos vendidos",
                      textAlign: pw.TextAlign.center,
                      style: const pw.TextStyle(
                        fontSize: 20,
                      ))),
              pw.Image(pw.MemoryImage(by)),
            ]));

    savePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Flexible(
              flex: 6,
              fit: FlexFit.tight,
              child: PieChart(
                animationDuration: const Duration(seconds: 0),
                dataMap: dataMap,
                legendLabels: legendLabels,
              )),
        ],
      ),
    ));
  }
}
