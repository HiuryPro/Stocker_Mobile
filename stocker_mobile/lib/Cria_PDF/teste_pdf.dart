import 'dart:convert';

import 'package:fl_chart/fl_chart.dart' as pie;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:html' as html;

import '../DadosDB/CRUD.dart';
import '../Validacao_e_Gambiarra/cores.dart';

//Thanks C Scutt for the pdf code, helped a lot

class Chart extends StatefulWidget {
  const Chart({Key? key}) : super(key: key);

  @override
  State<Chart> createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  List<Dados> data = [];
  List<String> venda = ["Suco", "Cerveja", "Puta", "Caralho"];
  List<double> preco = [10, 20, 30, 40];

  String deData = "";
  String ateData = "";

  var dadosBD = CRUD();

  Cores cor = Cores();
  final pdf = pw.Document();
  var anchor;
  var dateMask = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateMask2 = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < preco.length; i++) {
      data.add(Dados(venda[i], preco[i], cor.cores[i]));
    }

    // Page
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

  Future<List<List<dynamic>>> relatoriaDados() async {
    var dados = await dadosBD.selectPV(deData, ateData);

    List<List<dynamic>> teste = [];
    teste.add([
      'id',
      'produto',
      'quantidade',
      'preco',
      'total',
      'data de saída',
      'cliente'
    ]);
    for (int i = 0; i < dados.length; i = i + 7) {
      teste.add([
        '${dados[i]}',
        '${dados[i + 1]}',
        '${dados[i + 2]}',
        '${dados[i + 3]}',
        '${dados[i + 4]}',
        '${dados[i + 5]}',
        '${dados[i + 6]}'
      ]);
    }

    return teste;
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

  createPDF(List<List<dynamic>> valores, var image) async {
    pdf.addPage(pw.MultiPage(
        build: (context) => [
              pw.Center(
                  child: pw.SizedBox(child: pw.Image(pw.MemoryImage(image)))),
              pw.SizedBox(height: 20),
              pw.Center(
                  child: pw.Text("Relatório de Vendas",
                      style: const pw.TextStyle(fontSize: 30))),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(data: valores),
            ]));
    savePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            const SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: TextField(
                      onChanged: (text) {
                        deData = dateMask.getMaskedText();
                      },
                      inputFormatters: [dateMask],
                      decoration: const InputDecoration(
                        labelText: 'Dé',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: TextField(
                      onChanged: (text) {
                        ateData = dateMask2.getMaskedText();
                      },
                      inputFormatters: [dateMask2],
                      decoration: const InputDecoration(
                        labelText: 'Até',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                ),
              ],
            ),
            ElevatedButton(
                onPressed: () async {
                  var image =
                      (await rootBundle.load("images/Stocker_blue_transp.png"))
                          .buffer
                          .asUint8List();
                  await createPDF(await relatoriaDados(), image);
                  anchor.click();
                  Navigator.pop(context);
                },
                child: const Text("Cria pdf"))
          ],
        ),
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
