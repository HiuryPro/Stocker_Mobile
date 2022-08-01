import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stocker_mobile/Cria_PDF/chart.dart';
import 'package:stocker_mobile/Cria_PDF/chart2.dart';

import '../DadosDB/CRUD.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class CriaPDF {
  var dadosBD = CRUD();
  // ignore: prefer_typing_uninitialized_variables
  var anchor;

  String deData = "";
  String ateData = "";
  List<List<dynamic>> tabela = [];

  relatoriaDados() async {
    var dados = await dadosBD.selectPV(deData, ateData);

    tabela.add([
      'produto',
      'quantidade',
      'preco',
      'total',
      'data de saída',
      'cliente'
    ]);
    for (int i = 0; i < dados.length; i = i + 7) {
      tabela.add([
        '${dados[i + 1]}',
        '${dados[i + 2]}',
        '${dados[i + 3]}',
        '${dados[i + 4]}',
        '${dados[i + 5]}',
        '${dados[i + 6]}'
      ]);
    }
  }

  savePDFMob(var pdf) async {
    var bytes = await pdf.save();

    String path =
        '/storage/emulated/0/Download/Stocker/relatorio_${deData.replaceAll(RegExp(r'/'), '-')}_${ateData.replaceAll(RegExp(r'/'), '-')}.pdf';
    final File file = File(path);
    file.writeAsBytesSync(bytes);
  }

  savePDF(var pdf) async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'relatorio_${deData}_$ateData.pdf';
    html.document.body?.children.add(anchor);
  }

  createPDF() async {
    var pdf = pw.Document();
    ScreenshotController screenshotController = ScreenshotController();
    final bytes = await screenshotController.captureFromWidget(
      const MediaQuery(data: MediaQueryData(), child: Chart()),
    );
    final bytes2 = await screenshotController.captureFromWidget(
      const MediaQuery(
        data: MediaQueryData(),
        child: Chart2(),
      ),
    );

    var image = (await rootBundle.load("assets/images/Stocker_blue_transp.png"))
        .buffer
        .asUint8List();
    pdf.addPage(
      pw.MultiPage(
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
                    child: pw.SizedBox(child: pw.Image(pw.MemoryImage(image)))),
                pw.SizedBox(height: 20),
                pw.Center(
                    child: pw.Text("Relatório de Vendas",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 30))),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(data: tabela),
                pw.NewPage(),
                pw.Center(
                    child: pw.Text("Gráfico de quantidade de produtos vendidos",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 14,
                        ))),
                pw.SizedBox(height: 3),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320, child: pw.Image(pw.MemoryImage(bytes)))),
                pw.SizedBox(height: 3),
                pw.Center(
                    child: pw.Text(
                        textAlign: pw.TextAlign.center,
                        "Gráfico de total ganho na venda de cada produto",
                        style: const pw.TextStyle(fontSize: 14))),
                pw.SizedBox(height: 3),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320, child: pw.Image(pw.MemoryImage(bytes2)))),
              ]),
    );

    if (kIsWeb) {
      savePDF(pdf);
    } else {
      savePDFMob(pdf);
    }
  }

  criaDiretorio() async {
    String path = '/storage/emulated/0/Download/Stocker';
    Directory teste = Directory(path);
    try {
      await teste.create(recursive: false);
      print("Funciona eu acho");
    } catch (e) {
      print(e);
    }
  }
}
