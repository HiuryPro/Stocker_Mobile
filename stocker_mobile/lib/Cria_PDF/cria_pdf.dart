import 'dart:io';

import 'package:flutter/foundation.dart';
import '../DadosDB/crud.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

class CriaPDF {
  var crud = CRUD();
  // ignore: prefer_typing_uninitialized_variables
  var anchor;

  String deData = "";
  String ateData = "";
  List<List<dynamic>> tabela = [];

  relatoriaDados() async {
    var dados = await crud.select(
        "SELECT *, date_format(data_saida, '%d/%m/%Y') as datas  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\")) ORDER BY data_saida ");

    tabela.add([
      'produto',
      'quantidade',
      'preco',
      'total',
      'data de saída',
      'cliente'
    ]);

    for (var row in dados) {
      tabela.add([
        row['nome_produto'],
        row['quantidade'],
        row['preco_unitario'],
        row['total'],
        row['datas'],
        row['cliente']
      ]);
    }
  }

  savePDFMobile(var pdf) async {
    var bytes = await pdf.save();

    String path =
        '/storage/emulated/0/Download/Stocker/relatorio_${deData.replaceAll(RegExp(r'/'), '_')}_${ateData.replaceAll(RegExp(r'/'), '_')}.pdf';
    final File file = File(path);
    file.writeAsBytesSync(bytes);
  }

  savePDFWeb(var pdf) async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'relatorio_${deData}_$ateData.pdf';
    html.document.body?.children.add(anchor);
  }

  createPDF({var imageLogo, var bytesImage, var bytesImage2}) async {
    var pdf = pw.Document();
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
                    child: pw.SizedBox(
                        child: pw.Image(pw.MemoryImage(imageLogo)))),
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
                        height: 320,
                        child: pw.Image(pw.MemoryImage(bytesImage)))),
                pw.SizedBox(height: 3),
                pw.Center(
                    child: pw.Text(
                        textAlign: pw.TextAlign.center,
                        "Gráfico de total ganho na venda de cada produto",
                        style: const pw.TextStyle(fontSize: 14))),
                pw.SizedBox(height: 3),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320,
                        child: pw.Image(pw.MemoryImage(bytesImage2)))),
              ]),
    );

    if (kIsWeb) {
      savePDFWeb(pdf);
    } else {
      savePDFMobile(pdf);
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
