import 'dart:convert';

import 'package:fl_chart/fl_chart.dart' as pie;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:screenshot/screenshot.dart';
import 'dart:typed_data';
import 'dart:html' as html;

import '../Cria_PDF/chart.dart';
import '../Cria_PDF/chart2.dart';
import '../DadosDB/CRUD.dart';
import '../DadosDB/crud2.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/cores.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int count = 0;
  List<String> venda = ["Suco", "Cerveja", "Puta", "Caralho"];
  List<double> preco = [10, 20, 30, 40];

  String deData = "";
  String ateData = "";

  var dadosBD = CRUD();
  var dadosBD2 = CRUD2();

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

  createPDF(List<List<dynamic>> valores, var image, var by, var by2) async {
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
              pw.SizedBox(height: 20),
              pw.Center(
                  child: pw.SizedBox(child: pw.Image(pw.MemoryImage(by)))),
              pw.SizedBox(height: 20),
              pw.Center(
                  child: pw.SizedBox(child: pw.Image(pw.MemoryImage(by2)))),
            ]));
    savePDF();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dandjaro'),
        actions: [
          Switch(
            value: AppController.instance.isDarkTheme,
            onChanged: (value) {
              setState(() {
                AppController.instance.changeTheme();
              });
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Dandjaro $count",
                  style: const TextStyle(fontSize: 20),
                ),
                Switch(
                  value: AppController.instance.isDarkTheme,
                  onChanged: (value) {
                    setState(() {
                      AppController.instance.changeTheme();
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                    onPressed: () async {
                      dynamic list = [];
                    },
                    child: Text("Update"))
              ],
            ),
            Text(
              "Dandjaro $count",
              style: const TextStyle(fontSize: 20),
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
            Switch(
              value: AppController.instance.isDarkTheme,
              onChanged: (value) {
                setState(() {
                  AppController.instance.changeTheme();
                });
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            await dadosBD2.updateRTS(deData, ateData);
            ScreenshotController screenshotController = ScreenshotController();
            final bytes = await screenshotController.captureFromWidget(
                const MediaQuery(data: MediaQueryData(), child: Chart()));
            final bytes2 = await screenshotController.captureFromWidget(
                const MediaQuery(data: MediaQueryData(), child: Chart2()));
            var image =
                (await rootBundle.load("images/Stocker_blue_transp.png"))
                    .buffer
                    .asUint8List();
            await createPDF(await relatoriaDados(), image, bytes, bytes2);
            anchor.click();
            Navigator.pop(context);
          }),
    );
  }
}
