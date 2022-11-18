import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:universal_html/html.dart' as html;

import '../credentials/supabase.credentials.dart';

class CriaPDF {
  var crud = DataBaseService();
  // ignore: prefer_typing_uninitialized_variables
  var anchor;

  String deData = "";
  String ateData = "";
  List<List<dynamic>> tabela = [];

  relatoriaDadosCompra() async {
    tabela.clear();
    var dados = await SupaBaseCredentials.supaBaseClient.rpc('relatoriocompra',
        params: {'data1': deData, 'data2': ateData}).execute();

    tabela.add([
      'Produto',
      'Medida',
      'Número do Lote',
      'Quantidade',
      'Preco',
      'Frete',
      'Total',
      'Fornecedor',
      'Data de Compra',
    ]);

    for (var row in dados.data) {
      tabela.add([
        row['nomep'],
        row['medida'],
        row['numerol'],
        row['qtd'],
        row['preco'],
        row['frete'],
        ((row['preco'] * row['qtd']) + row['frete']).toStringAsFixed(2),
        row['nomef'],
        row['data'],
      ]);
    }
  }

  relatoriaDadosVenda() async {
    tabela.clear();
    var dados = await SupaBaseCredentials.supaBaseClient.rpc('relatoriovenda',
        params: {'data1': deData, 'data2': ateData}).execute();

    tabela.add([
      'Produto',
      'Medida',
      'Nº do Lote',
      'Qtd',
      'Preco',
      'Adicional',
      'Desconto',
      'Total',
      'Cliente',
      'Data de Compra',
    ]);

    for (var row in dados.data) {
      tabela.add([
        row['nomep'],
        row['medida'],
        row['numerol'],
        row['qtd'],
        row['preco'],
        "${row['adicional']}%",
        "${row['desconto']}%",
        retornaTotal(
                row['qtd'], row['preco'], row['adicional'], row['desconto'])
            .toStringAsFixed(2),
        row['nomec'],
        row['data'],
      ]);
    }
  }

  double retornaTotal(int qtd, double prec, double adic, double desc) {
    double preTotal = (qtd * prec);
    double preTotalComAdicional = preTotal + (preTotal * (adic / 100));
    double total = preTotalComAdicional - (preTotalComAdicional * (desc / 100));

    return total;
  }

  savePDFMobile(var pdf, String nome) async {
    var bytes = await pdf.save();

    String path =
        '/storage/emulated/0/Download/Stocker/relatorio_${nome}_${deData.replaceAll(RegExp(r'/'), '_')}_${ateData.replaceAll(RegExp(r'/'), '_')}.pdf';
    final File file = File(path);
    file.writeAsBytesSync(bytes);
  }

  savePDFWeb(var pdf, String nome) async {
    Uint8List pdfInBytes = await pdf.save();
    final blob = html.Blob([pdfInBytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'relatori_${nome}_${deData}_$ateData.pdf';
    html.document.body?.children.add(anchor);
  }

  createPDFCompra({var imageLogo, var bytesImage, var bytesImage2}) async {
    var pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
          footer: (pw.Context context) {
            return pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                child: pw.Text(
                    'Página ${context.pageNumber} of ${context.pagesCount}',
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
                    child: pw.Text("Relatório de Compras",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(fontSize: 30))),
                pw.SizedBox(height: 20),
                pw.Table.fromTextArray(
                    data: tabela,
                    defaultColumnWidth: const pw.IntrinsicColumnWidth(flex: 1),
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    headerStyle: const pw.TextStyle(fontSize: 10),
                    headerAlignment: pw.Alignment.topLeft),
                pw.NewPage(),
                pw.Center(
                    child:
                        pw.Text("Gráfico de quantidade de produtos comprados",
                            textAlign: pw.TextAlign.center,
                            style: const pw.TextStyle(
                              fontSize: 14,
                            ))),
                pw.SizedBox(height: 5),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320,
                        child: pw.Image(pw.MemoryImage(bytesImage)))),
                pw.SizedBox(height: 5),
                pw.Center(
                    child: pw.Text(
                        textAlign: pw.TextAlign.center,
                        "Gráfico de total gasto na compra de cada tipo de produto",
                        style: const pw.TextStyle(fontSize: 14))),
                pw.SizedBox(height: 5),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320,
                        child: pw.Image(pw.MemoryImage(bytesImage2)))),
              ]),
    );

    if (kIsWeb) {
      savePDFWeb(pdf, "compra");
    } else {
      savePDFMobile(pdf, "compra");
    }
  }

  createPDFVenda({var imageLogo, var bytesImage, var bytesImage2}) async {
    var pdf = pw.Document();
    pdf.addPage(
      pw.MultiPage(
          footer: (pw.Context context) {
            return pw.Container(
                alignment: pw.Alignment.centerRight,
                margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
                child: pw.Text(
                    'Página ${context.pageNumber} of ${context.pagesCount}',
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
                pw.Table.fromTextArray(
                    data: tabela,
                    defaultColumnWidth: const pw.IntrinsicColumnWidth(flex: 1),
                    cellStyle: const pw.TextStyle(fontSize: 10),
                    headerStyle: const pw.TextStyle(fontSize: 10),
                    headerAlignment: pw.Alignment.topLeft),
                pw.NewPage(),
                pw.Center(
                    child: pw.Text("Gráfico de quantidade de produtos vendidos",
                        textAlign: pw.TextAlign.center,
                        style: const pw.TextStyle(
                          fontSize: 14,
                        ))),
                pw.SizedBox(height: 5),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320,
                        child: pw.Image(pw.MemoryImage(bytesImage)))),
                pw.SizedBox(height: 5),
                pw.Center(
                    child: pw.Text(
                        textAlign: pw.TextAlign.center,
                        "Gráfico de total ganho na venda de cada tipo de produto",
                        style: const pw.TextStyle(fontSize: 14))),
                pw.SizedBox(height: 5),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320,
                        child: pw.Image(pw.MemoryImage(bytesImage2)))),
              ]),
    );

    if (kIsWeb) {
      savePDFWeb(pdf, "venda");
    } else {
      savePDFMobile(pdf, "venda");
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
