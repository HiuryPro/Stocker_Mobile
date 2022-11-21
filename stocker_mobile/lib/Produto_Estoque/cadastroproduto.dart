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
import 'package:universal_html/html.dart';

import '../Validacao_e_Gambiarra/voz.dart';

class CadProduto extends StatefulWidget {
  const CadProduto({super.key});

  @override
  State<CadProduto> createState() => _CadProdutoState();
}

class _CadProdutoState extends State<CadProduto> {
  Map<String, TextEditingController> controllersProduto = {
    'produto': TextEditingController(),
    'descricao': TextEditingController(),
  };

  Map<String, TextEditingController> controllersLote = {
    'numeroLote': TextEditingController(),
    'quantidade': TextEditingController(),
    'precoUnd': TextEditingController(),
    'descricao': TextEditingController(),
    'dataVencimento': TextEditingController(),
    'dataFabricacao': TextEditingController()
  };

  Map<String, String?> mensagemDeErroProduto = {
    'produto': null,
    'descricao': null
  };

  Map<String, String?> mensagemDeErroLote = {
    'numeroLote': null,
    'quantidade': null,
    'precoUnd': null,
    'descricao': null,
    'dataVencimento': null,
    'dataFabricacao': null
  };

  bool isDataDeVencimento = true;
  bool isDataDeFabricacao = true;
  final produtos = [""];
  final undMedidas = [''];
  String? produto;
  String? medida;

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
        await window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }

      var medidas = await crud.selectWithOrder(
          tabela: 'UndMedida',
          select: 'IdUndMedida, Medida',
          where: {},
          order: 'IdUndMedida');

      var lista = await crud.selectInner(
          tabela: "Produto", select: 'IdProduto, NomeProduto', where: {});
      print(lista);
      print(medidas);
      if (lista != null) {
        setState(() {
          for (var row in lista) {
            produtos.add("${row["IdProduto"]} ${row["NomeProduto"]}");
          }
          for (var row in medidas) {
            undMedidas.add("${row["IdUndMedida"]} ${row["Medida"]}");
          }
        });
      }
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
            const Text('Cadastro de Produto', style: TextStyle(fontSize: 30)),
            const SizedBox(
              height: 15,
            ),
            TextField(
                controller: controllersProduto['produto'],
                onChanged: ((value) {
                  setState(() {
                    mensagemDeErroProduto['produto'] = null;
                  });
                }),
                inputFormatters: [],
                decoration: InputDecoration(
                    label: const Text('Produto'),
                    border: const OutlineInputBorder(),
                    errorText: mensagemDeErroProduto['produto'])),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: (medida != null)
                          ? const Color(0xFF0080d9)
                          : Colors.red,
                      width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: medida,
                    menuMaxHeight: 200,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Unidade de Medida"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items: undMedidas.map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        medida = value;
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
                  if (isTudoPreenchido && medida != null) {
                    print(AppController.instance.response!.user!.id);
                    print(SupaBaseCredentials
                        .supaBaseClient.auth.currentUser!.id);
                    var idEmpresa = await crud.select(
                        tabela: 'Empresa',
                        select: 'IdEmpresa',
                        where: {
                          'IdAdministrador':
                              AppController.instance.response!.user!.id
                        });
                    print(idEmpresa);
                    var responseProduto =
                        await crud.insert(tabela: 'Produto', map: {
                      'NomeProduto': controllersProduto['produto']!.text,
                      'Descricao': controllersProduto['descricao']!.text,
                      'IdMedida': apenasNumeros(medida!),
                      'IdEmpresa': idEmpresa[0]['IdEmpresa']
                    });
                    setState(() {
                      produtos.clear();
                    });
                    print(responseProduto);
                    var lista = await crud.selectInner(
                        tabela: "Produto",
                        select: 'IdProduto, NomeProduto',
                        where: {});
                    print(lista);
                    if (lista != null) {
                      setState(() {
                        for (var row in lista) {
                          produtos
                              .add("${row["IdProduto"]} ${row["NomeProduto"]}");
                        }
                      });
                    }
                    clearCamposProduto();
                    setState(() {
                      medida = null;
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
                      child: Text("Produtos"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items: produtos.map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        produto = value;
                      });
                    }),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
                onChanged: (value) {
                  setState(() {
                    mensagemDeErroLote['numeroLote'] = null;
                  });
                },
                controller: controllersLote['numeroLote'],
                decoration: InputDecoration(
                    label: const Text('Número do Lote'),
                    border: const OutlineInputBorder(),
                    errorText: mensagemDeErroLote['numeroLote'])),
            const SizedBox(
              height: 15,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  mensagemDeErroLote['quantidade'] = null;
                });
              },
              controller: controllersLote['quantidade'],
              decoration: InputDecoration(
                  label: const Text("Quantidade"),
                  border: const OutlineInputBorder(),
                  errorText: mensagemDeErroLote['quantidade']),
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
            const SizedBox(
              height: 15,
            ),
            TextField(
              onChanged: ((value) {
                setState(() {
                  mensagemDeErroLote['dataFabricacao'] = null;
                });
              }),
              inputFormatters: [dateMaskFabricacao],
              enabled: isDataDeFabricacao,
              controller: controllersLote['dataFabricacao'],
              decoration: InputDecoration(
                  label: const Text('Data de Fabricação'),
                  border: const OutlineInputBorder(),
                  errorText: mensagemDeErroLote['dataFabricacao']),
            ),
            Row(
              children: [
                Checkbox(
                    value: !isDataDeFabricacao,
                    onChanged: (valor) {
                      setState(() {
                        mensagemDeErroLote['dataFabricacao'];
                        isDataDeFabricacao = !isDataDeFabricacao;
                      });
                    }),
                const Text('Caso não haja data de fabricação')
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  mensagemDeErroLote['dataVencimento'] = null;
                });
              },
              inputFormatters: [dateMaskVencimento],
              enabled: isDataDeVencimento,
              controller: controllersLote['dataVencimento'],
              decoration: InputDecoration(
                  label: const Text('Data de Vencimento'),
                  border: const OutlineInputBorder(),
                  errorText: mensagemDeErroLote['dataVencimento']),
            ),
            Row(
              children: [
                Checkbox(
                    value: !isDataDeVencimento,
                    onChanged: (valor) {
                      setState(() {
                        mensagemDeErroLote['dataVencimento'];
                        isDataDeVencimento = !isDataDeVencimento;
                      });
                    }),
                const Text('Caso não haja data de vencimento')
              ],
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
                        print(key);
                        if ((key == 'dataFabricacao' && !isDataDeFabricacao) ||
                            (key == 'dataVencimento' && !isDataDeVencimento)) {
                          print('Entro');
                        } else {
                          mensagemDeErroLote[key] = 'Campo está vazio';
                          isTudoPreenchido = false;
                          print(value.text);
                        }
                      });
                    }
                  });

                  if (isTudoPreenchido && produto != null) {
                    var loteResultado;
                    var produtos = await crud.selectInner(
                        tabela: 'Lote',
                        select: 'NumeroLote, IdProduto',
                        where: {});

                    for (var row in produtos) {
                      if (row['IdProduto'] == apenasNumeros(produto!) &&
                          row['NumeroLote'] ==
                              controllersLote['numeroLote']!.text) {
                        isExistente = true;
                      }
                    }
                    if (!isExistente) {
                      if (isDataDeFabricacao && isDataDeVencimento) {
                        loteResultado = await crud.insert(tabela: 'Lote', map: {
                          'NumeroLote': controllersLote['numeroLote']!.text,
                          'IdProduto': apenasNumeros(produto!),
                          'DataVencimento': DateFormat.yMMMd().add_Hm().format(
                              DateFormat("dd/MM/yyyy")
                                  .parse(dateMaskVencimento.getMaskedText())),
                          'DataFabricacao': DateFormat.yMMMd().add_Hm().format(
                              DateFormat("dd/MM/yyyy")
                                  .parse(dateMaskFabricacao.getMaskedText())),
                          'Descricao': controllersLote['descricao']!.text,
                        });
                        print(loteResultado);
                        print(DateFormat("dd/MM/yyyy")
                            .parse(dateMaskFabricacao.getMaskedText()));
                      } else if (isDataDeFabricacao) {
                        loteResultado = await crud.insert(tabela: 'Lote', map: {
                          'NumeroLote':
                              int.parse(controllersLote['numeroLote']!.text),
                          'IdProduto': apenasNumeros(produto!),
                          'DataFabricacao': DateFormat.yMMMd().add_Hm().format(
                              DateFormat("dd/MM/yyyy")
                                  .parse(dateMaskFabricacao.getMaskedText())),
                          'Descricao': controllersLote['descricao']!.text,
                        });
                        print(loteResultado);
                      } else if (isDataDeVencimento) {
                        loteResultado = await crud.insert(tabela: 'Lote', map: {
                          'NumeroLote':
                              int.parse(controllersLote['numeroLote']!.text),
                          'IdProduto': apenasNumeros(produto!),
                          'DataVencimento': DateFormat.yMMMd().add_Hm().format(
                              DateFormat("dd/MM/yyyy")
                                  .parse(dateMaskVencimento.getMaskedText())),
                          'Descricao': controllersLote['descricao']!.text,
                        });
                        print(loteResultado);
                      } else {
                        loteResultado = await crud.insert(tabela: 'Lote', map: {
                          'NumeroLote':
                              int.parse(controllersLote['numeroLote']!.text),
                          'IdProduto': apenasNumeros(produto!),
                          'Descricao': controllersLote['descricao']!.text,
                        });
                        print(loteResultado);
                      }
                      var estoqueResultado =
                          await crud.insert(tabela: 'Estoque', map: {
                        'IdLote': loteResultado[0]['IdLote'],
                        'Quantidade':
                            int.parse(controllersLote['quantidade']!.text),
                        'PrecoMPM':
                            double.parse(controllersLote['precoUnd']!.text)
                      });
                      print(estoqueResultado);
                      var snack = const SnackBar(
                        content: Text('Cadastro de lote feito com sucesso'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                    } else {
                      var snack = const SnackBar(
                        content: Text(
                            'Esse Lote já existe. Vá para a tela de Estoque para alterar lote'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snack);
                      setState(() {
                        produto = null;
                        controllersLote['numeroLote']!.text = "";
                      });
                    }
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

/*
   bool isPreechido() {
    bool isPreenchido = true;
    for (int i = 0; i < textControllers.length; i++) {
      if (textControllers[i].text == "") {
        setState(() {
          mensagemDeErro[i] = "Campo está vazio";
        });
        isPreenchido = false;
      }
    }
    return isPreenchido;
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.phone),
            onPressed: () async {
              print(this.context);
              Voz.instance.opcao = 0;
              Voz.instance.context = this.context;
              await Voz.instance.initSpeechState();

              await Voz.instance.initTts();
              await Voz.instance.buscaComandos();

              Voz.instance.startListening();

              //  navegar.navegarEntreTela(voz.navegar, context);
            }),
        appBar: AppBar(
          foregroundColor: AppController.instance.theme1,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        drawer: drawerTela.drawerTela(context),
        body: body());
  }
}
