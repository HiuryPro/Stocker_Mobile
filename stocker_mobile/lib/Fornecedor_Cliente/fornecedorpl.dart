import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/drawertela.dart';
import 'package:stocker_mobile/credentials/supabase.credentials.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';
import 'package:universal_html/html.dart' as html;

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/falapratexto.dart';
import '../Validacao_e_Gambiarra/textoprafala.dart';

class CadFornePL extends StatefulWidget {
  const CadFornePL({super.key});

  @override
  State<CadFornePL> createState() => _CadFornePLState();
}

class _CadFornePLState extends State<CadFornePL> {
  Map<String, TextEditingController> controllersProduto = {
    'descricao': TextEditingController(),
  };

  Map<String, TextEditingController> controllersLote = {
    'frete': TextEditingController(),
    'precoUnd': TextEditingController(),
    'descricao': TextEditingController(),
  };

  Map<String, String?> mensagemDeErroProduto = {'descricao': null};

  Map<String, String?> mensagemDeErroLote = {
    'frete': null,
    'precoUnd': null,
    'descricao': null,
  };

  Map<String, int> produtos = {};
  Map<String, int> produtosL = {};
  Map<String, int> fornecedores = {};
  Map<String, int> lotes = {};

  bool isDataDeVencimento = true;
  bool isDataDeFabricacao = true;
  final undMedidas = [''];
  String? produto;
  String? fornecedor;
  String? fornecedorL;
  String? produtoL;
  String? numlote;

  var drawerTela = DrawerTela();

  var dateMaskFabricacao = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateMaskVencimento = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var crud = DataBaseService();

  clearCamposProduto() {
    controllersProduto.forEach((key, value) {
      setState(() {
        value.clear();
      });
    });
  }

  clearCamposLote() {
    controllersLote.forEach((key, value) {
      setState(() {
        value.clear();
      });
    });
  }

//

  @override
  void initState() {
    produtos.clear();
    undMedidas.clear();
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await html.window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }

      var forn = await crud.selectInner(
          tabela: 'Fornecedor',
          select: "IdFornecedor, Pessoa!inner(Nome)",
          where: {});
      print(forn);

      if (forn != null) {
        setState(() {
          for (var row in forn) {
            fornecedores.addAll({row['Pessoa']['Nome']: row['IdFornecedor']});
          }
        });
      }
      await Navegar.instance.buscaComandos();
    });
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: ListView(shrinkWrap: true, children: [
            const Text('Cadastro de Fornecedor por Produto',
                style: TextStyle(fontSize: 30)),
            const SizedBox(
              height: 15,
            ),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (fornecedor != null)
                          ? const Color(0xFF0080d9)
                          : Colors.red,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: fornecedor,
                    menuMaxHeight: 200,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Fornecedor"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items:
                        fornecedores.keys.toList().map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        fornecedor = value;
                      });

                      var produtosFExistentes = await crud.selectInner(
                          tabela: 'FornecedorProduto',
                          select:
                              "IdProduto, Produto!inner(NomeProduto), IdFornecedor, Fornecedor!inner(Pessoa!inner(Nome))",
                          where: {'IdFornecedor': fornecedores[fornecedor]});
                      print(produtosFExistentes);

                      List<dynamic> produtosR = await crud.select(
                          tabela: 'Produto',
                          select: 'NomeProduto, IdProduto',
                          where: {});

                      for (Map row in produtosR) {
                        for (Map row2 in produtosFExistentes) {
                          print(row2['Produto']['NomeProduto']);
                          if (row['NomeProduto'] ==
                              row2['Produto']['NomeProduto']) {
                            row.clear();
                          }
                        }
                      }

                      produtosR.removeWhere((item) => item.isEmpty);
                      print(produtosR);
                      setState(() {
                        for (var row in produtosR) {
                          produtos
                              .addAll({row['NomeProduto']: row['IdProduto']});
                        }
                      });
                    }),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (produto != null)
                          ? const Color(0xFF0080d9)
                          : Colors.red,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: produto,
                    menuMaxHeight: 200,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Produto"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items: produtos.keys.toList().map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        produto = value;
                      });
                    }),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersProduto['descricao'],
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              onChanged: (value) {
                setState(() {
                  mensagemDeErroProduto['descricao'] = null;
                });
              },
              decoration: InputDecoration(
                  label: const Text('Descrição'),
                  border: const OutlineInputBorder(),
                  errorText: mensagemDeErroProduto['descricao']),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () async {
                  bool isTudoPreenchido = true;

                  controllersProduto.forEach((key, value) {
                    if (value.text == '') {
                      setState(() {
                        mensagemDeErroProduto[key] = 'Campo está vazio';
                        isTudoPreenchido = false;
                        print(value.text);
                      });
                    }
                  });
                  if (isTudoPreenchido &&
                      fornecedor != null &&
                      produto != null) {
                    var responseFornecedorP =
                        await crud.insert(tabela: 'FornecedorProduto', map: {
                      'IdFornecedor': fornecedores[fornecedor],
                      'IdProduto': produtos[produto],
                      'Descricao': controllersProduto['descricao']!.text,
                    });
                    print(responseFornecedorP);
                    setState(() {
                      produtos.clear();

                      produto = null;
                      fornecedor = null;
                    });
                  } else {
                    const SnackBar(
                      content: Text('Há campos vazios'),
                    );
                  }
                },
                child: const Text('Cadastrar Produto')),
            const SizedBox(
              height: 30,
            ),
            const Text('Cadastro de Lote', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (fornecedorL != null)
                          ? const Color(0xFF0080d9)
                          : Colors.red,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: fornecedorL,
                    menuMaxHeight: 200,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Fornecedor"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items:
                        fornecedores.keys.toList().map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        fornecedorL = value;
                        produtosL.clear();
                        lotes.clear();
                        produtoL = null;
                        numlote = null;
                      });

                      var pegaProduto = await crud.selectInner(
                          tabela: 'FornecedorProduto',
                          select: 'Produto!inner(IdProduto, NomeProduto)',
                          where: {'IdFornecedor': fornecedores[fornecedorL]});
                      print(pegaProduto);
                      for (var row in pegaProduto) {
                        setState(() {
                          produtosL.addAll({
                            row['Produto']['NomeProduto']: row['Produto']
                                ['IdProduto']
                          });
                        });
                      }
                    }),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (produtoL != null)
                          ? const Color(0xFF0080d9)
                          : Colors.red,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: produtoL,
                    menuMaxHeight: 200,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Produto"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items: produtosL.keys.toList().map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        produtoL = value;
                        lotes.clear();
                        numlote = null;
                      });
                      var loteFExistentes = await crud.selectInner(
                          tabela: 'FornecedorPLote',
                          select:
                              "FornecedorProduto!inner(IdProduto, IdFornecedor), Lote!inner(IdLote, NumeroLote), IdLote",
                          where: {
                            'FornecedorProduto.IdFornecedor':
                                fornecedores[fornecedorL],
                            'FornecedorProduto.IdProduto': produtosL[produtoL]
                          });
                      print(loteFExistentes);

                      List<dynamic> lotesR = await crud.select(
                          tabela: 'Lote',
                          select: 'IdLote, NumeroLote',
                          where: {'IdProduto': produtosL[produtoL]});

                      for (Map row in lotesR) {
                        for (Map row2 in loteFExistentes) {
                          print(row2['Lote']['IdLote']);
                          if (row['IdLote'] == row2['Lote']['IdLote']) {
                            row.clear();
                          }
                        }
                      }

                      lotesR.removeWhere((item) => item.isEmpty);
                      print(lotesR);
                      setState(() {
                        for (var row in lotesR) {
                          lotes.addAll({row['NumeroLote']: row['IdLote']});
                        }
                      });
                    }),
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (numlote != null)
                          ? const Color(0xFF0080d9)
                          : Colors.red,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: numlote,
                    menuMaxHeight: 200,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Lote"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items: lotes.keys.toList().map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        numlote = value;
                      });
                    }),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  mensagemDeErroLote['frete'] = null;
                });
              },
              controller: controllersLote['frete'],
              decoration: InputDecoration(
                  label: const Text("Frete"),
                  border: const OutlineInputBorder(),
                  errorText: mensagemDeErroLote['frete']),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllersLote['precoUnd'],
              onChanged: (value) {
                setState(() {
                  mensagemDeErroLote['precoUnd'] = null;
                });
              },
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              decoration: InputDecoration(
                  labelText: 'Preco Unitário',
                  border: const OutlineInputBorder(),
                  errorText: mensagemDeErroLote['precoUnd']),
            ),
            const SizedBox(height: 15),
            TextField(
              onChanged: (value) {
                setState(() {
                  mensagemDeErroLote['descricao'] = null;
                });
              },
              controller: controllersLote['descricao'],
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                  label: const Text('Descrição do Lote'),
                  border: const OutlineInputBorder(),
                  errorText: mensagemDeErroLote['descricao']),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  bool isTudoPreenchido = true;
                  bool isExistente = false;

                  controllersLote.forEach((key, value) {
                    if (value.text == '') {
                      setState(() {
                        mensagemDeErroLote[key] = 'Campo está vazio';
                        isTudoPreenchido = false;
                        print(value.text);
                      });
                    }
                  });

                  if (isTudoPreenchido &&
                      produtoL != null &&
                      fornecedorL != null &&
                      numlote != null) {
                    var idFornP = await crud.select(
                        tabela: 'FornecedorProduto',
                        select: 'IdFornecedorProduto',
                        where: {
                          'IdFornecedor': fornecedores[fornecedorL],
                          'IdProduto': produtosL[produtoL],
                        });
                    print(idFornP);
                    var resposta =
                        await crud.insert(tabela: 'FornecedorPLote', map: {
                      "IdFornecedorProduto": idFornP[0]['IdForncedorProduto'],
                      'IdLote': lotes[numlote],
                      'Preco': double.parse(controllersLote['precoUnd']!.text),
                      'Frete': double.parse(controllersLote['frete']!.text),
                      'Descricao': controllersLote['descricao']!.text
                    });
                    print(resposta);

                    setState(() {
                      produtosL.clear();
                      lotes.clear();
                      fornecedorL = null;
                      produtoL = null;
                      numlote = null;
                      controllersLote.forEach((key, value) {
                        value.text = '';
                      });
                    });
                  } else {
                    var snack = const SnackBar(
                      content: Text('Há campos vazios'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snack);
                  }
                },
                child: const Text('Cadastrar Lote')),
          ]))),
    );
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(item,
            style: const TextStyle(
              fontSize: 20,
            )),
      ));

  int apenasNumeros(String idNoText) {
    String soId = idNoText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(soId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: GestureDetector(
          onLongPress: () {
            print('segura');
          },
          onLongPressStart: (detaisl) async {
            await Fala.instance.somEntrou();
            Voz.instance.startListening();
            print('Começou a clicar');
          },
          onLongPressEnd: ((details) async {
            await Fala.instance.somSaiu();
            await Future.delayed(Duration(milliseconds: 500));
            Voz.instance.stopListening();
            await Navegar.instance.navegar(Voz.instance.lastWords, context);
          }),
          child: FloatingActionButton(
              child: Icon(Icons.phone), onPressed: () async {}),
        ),
        appBar: AppBar(
          foregroundColor: AppController.instance.theme1,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        drawer: drawerTela.drawerTela(context),
        body: body());
  }
}
