import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
import 'package:universal_html/html.dart' as html;

import '../Cria_PDF/cria_pdf.dart';
import '../Cria_PDF/uint.dart';

import '../DadosDB/crud.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/cores.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int count = 0;

  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  List<String> venda = ["Suco", "Cerveja", "Puta", "Caralho"];
  List<double> preco = [10, 20, 30, 40];

  String deData = "";
  String ateData = "";
  bool carrega = false;
  bool isDone = false;

  var dadosBD = CRUD();
  var criaPdf = CriaPDF();

  Cores cor = Cores();

  // ignore: prefer_typing_uninitialized_variables
  var anchor;

  var dateMask = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateMask2 = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

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

  createPDF(
      var pdf, List<List<dynamic>> valores, var image, var by, var by2) async {
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
                pw.Table.fromTextArray(data: valores),
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
                        height: 320, child: pw.Image(pw.MemoryImage(by)))),
                pw.SizedBox(height: 3),
                pw.Center(
                    child: pw.Text(
                        textAlign: pw.TextAlign.center,
                        "Gráfico de total ganho na venda de cada produto",
                        style: const pw.TextStyle(fontSize: 14))),
                pw.SizedBox(height: 3),
                pw.Center(
                    child: pw.SizedBox(
                        height: 320, child: pw.Image(pw.MemoryImage(by2)))),
              ]),
    );

    if (kIsWeb) {
      savePDF(pdf);
    } else {
      savePDFMob(pdf);
    }
  }

  Widget body() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: TextField(
                      readOnly: true,
                      controller: fieldText,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1980),
                                lastDate: DateTime(3000))
                            .then((date) {
                          if (date != null) {
                            fieldText.text =
                                DateFormat('dd/MM/yyyy').format(date);
                            deData = fieldText.text;
                          }
                        });
                      },

                      //inputFormatters: [dateMask],
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
                      readOnly: true,
                      controller: fieldText2,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1980),
                                lastDate: DateTime(3000))
                            .then((date) {
                          if (date != null) {
                            fieldText2.text =
                                DateFormat('dd/MM/yyyy').format(date);
                            ateData = fieldText2.text;
                          }
                        });
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
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/");
                },
                child: const Text("Voltar")),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  var lista = [];

                  setState(() {
                    carrega = true;
                  });

                  if (kIsWeb) {
                    lista = await dadosBD.select(
                        "SELECT *, date_format(data_saida, '%d/%m/%Y') as datas  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\")) ORDER BY data_saida ");

                    if (lista.isNotEmpty) {
                      await dadosBD.update(
                          "UPDATE relatoriototal set qtd_total = ?, preco_total = ?",
                          [0, 0]);
                      var dados = await dadosBD.select(
                          "SELECT nome_produto  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\"))");
                      for (var row in dados) {
                        var dados2 = await dadosBD.select(
                            "SELECT SUM(quantidade), SUM(total)  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\")) and nome_produto = '${row['nome_produto']}' ORDER BY data_saida ");
                        for (var row2 in dados2) {
                          await dadosBD.update(
                              "UPDATE relatoriototal set qtd_total = ?, preco_total = ? where nome_produto = '${row['nome_produto']}'",
                              [row2['SUM(quantidade)'], row['SUM(total)']]);
                        }
                      }
                      criaPdf.deData = deData;
                      criaPdf.ateData = ateData;
                      var teste2 = Uint();
                      await teste2.pegaImagem();
                      await criaPdf.relatoriaDados();
                      await criaPdf.createPDF(
                          teste2.image, teste2.bytes, teste2.bytes2);
                      criaPdf.anchor.click();

                      setState(() {
                        carrega = false;
                      });

                      mensagem(
                          "Relatório gerado com sucesso! Arquivo baixado na pasta dowloads");
                    } else {
                      setState(() {
                        carrega = false;
                      });
                      mensagem("Não há registros neste período");
                    }
                  } else {
                    if (await Permission.storage.isGranted) {
                      await criaPdf.criaDiretorio();

                      lista = await dadosBD.select(
                          "SELECT *, date_format(data_saida, '%d/%m/%Y') as datas  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\")) ORDER BY data_saida ");
                      if (lista.isNotEmpty) {
                        await dadosBD.update(
                            "UPDATE relatoriototal set qtd_total = ?, preco_total = ?",
                            [0, 0]);
                        var dados = await dadosBD.select(
                            "SELECT nome_produto  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\"))");
                        for (var row in dados) {
                          var dados2 = await dadosBD.select(
                              "SELECT SUM(quantidade), SUM(total)  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\")) and nome_produto = '${row['nome_produto']}' ORDER BY data_saida ");
                          for (var row2 in dados2) {
                            await dadosBD.update(
                                "UPDATE relatoriototal set qtd_total = ?, preco_total = ? where nome_produto = '${row['nome_produto']}'",
                                [row2['SUM(quantidade)'], row['SUM(total)']]);
                          }
                        }

                        criaPdf.deData = deData;
                        criaPdf.ateData = ateData;
                        var teste2 = Uint();
                        await teste2.pegaImagem();
                        await criaPdf.relatoriaDados();
                        await criaPdf.createPDF(
                            teste2.image, teste2.bytes, teste2.bytes2);
                        setState(() {
                          carrega = false;
                        });
                        mensagem(
                            "Relatório gerado com sucesso! Arquivo baixado na pasta dowloadas");
                      } else {
                        setState(() {
                          carrega = false;
                        });
                        mensagem("Não há registros neste período");
                      }
                    } else {
                      await [Permission.storage].request();

                      if (await Permission.storage.isGranted) {
                        await criaPdf.criaDiretorio();

                        lista = await dadosBD.select(
                            "SELECT *, date_format(data_saida, '%d/%m/%Y') as datas  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\")) ORDER BY data_saida ");
                        if (lista.isNotEmpty) {
                          await dadosBD.update(
                              "UPDATE relatoriototal set qtd_total = ?, preco_total = ?",
                              [0, 0]);
                          var dados = await dadosBD.select(
                              "SELECT nome_produto  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\"))");
                          for (var row in dados) {
                            var dados2 = await dadosBD.select(
                                "SELECT SUM(quantidade), SUM(total)  FROM produto_venda  where (data_saida BETWEEN STR_TO_DATE( '$deData' , \"%d/%m/%Y\") AND STR_TO_DATE( '$ateData' , \"%d/%m/%Y\")) and nome_produto = '${row['nome_produto']}' ORDER BY data_saida ");
                            for (var row2 in dados2) {
                              await dadosBD.update(
                                  "UPDATE relatoriototal set qtd_total = ?, preco_total = ? where nome_produto = '${row['nome_produto']}'",
                                  [row2['SUM(quantidade)'], row['SUM(total)']]);
                            }
                          }

                          criaPdf.deData = deData;
                          criaPdf.ateData = ateData;
                          var teste2 = Uint();
                          await teste2.pegaImagem();
                          await criaPdf.relatoriaDados();
                          await criaPdf.createPDF(
                              teste2.image, teste2.bytes, teste2.bytes2);
                          setState(() {
                            carrega = false;
                          });
                          mensagem(
                              "Relatório gerado com sucesso! Arquivo baixado na pasta dowloadas");
                        } else {
                          setState(() {
                            carrega = false;
                          });
                          mensagem("Não há registros neste período");
                        }
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Need permissions"),
                        ));
                      }
                    }
                  }
                },
                child: const Text("Cria PDF")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        body(),
        if (carrega) telaCarrega()[0],
        if (carrega) telaCarrega()[1],
      ],
    ));
  }

  List<Widget> telaCarrega() {
    return [
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white.withOpacity(0.7),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                  child: CircularProgressIndicator(color: Color(0xFF0080d9))),
              SizedBox(height: 10),
              Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      "Espere! Seu relatório está sendo gerado!",
                      style: TextStyle(fontSize: 25))),
            ]),
      ),
    ];
  }

  Widget alert(String mensagem) {
    return AlertDialog(
      title: const Text("Relatório"),
      content: Text(
        mensagem,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"))
      ],
    );
  }

  mensagem(String mensagem) {
    return showDialog(
      context: context,
      builder: (_) => alert(mensagem),
      barrierDismissible: true,
    );
  }
}
