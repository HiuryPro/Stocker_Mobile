import 'dart:io' as plataforma;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:universal_html/html.dart' as html;
import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
import '../Validacao_e_Gambiarra/falapratexto.dart';
import '../Validacao_e_Gambiarra/textoprafala.dart';
import '../services/supabase.databaseService.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class Compra extends StatefulWidget {
  const Compra({Key? key}) : super(key: key);

  @override
  State<Compra> createState() => _CompraState();
}

class _CompraState extends State<Compra> {
  var drawerTela = DrawerTela();

  var fieldControllerTotal = TextEditingController();

  Map<String, TextEditingController> controllersCompra = {
    'preco': TextEditingController(),
    'frete': TextEditingController(),
    'qtd': TextEditingController()
  };

  var crud = DataBaseService();

  String? produto;
  Map<String, int> produtos = {};
  Map<String, int> fornecedores = {};

  String? fornecedor;
  int? quantidade;
  double? preco;
  double? frete;
  double? total;
  int quantidadeLinhas = 0;
  List<bool> selecionado = [];
  List<Map> preCompra = [];
  Map<String, int> lotes = {};
  String? lote;

  var dateMaskFabricacao = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateMaskVencimento = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    produtos.clear();
    print('Funciona inferno');
    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await html.window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }
      var listaProdutos = await crud.select(
          tabela: "FornecedorProduto",
          select: 'Produto!inner(IdProduto, NomeProduto)',
          where: {});
      print(listaProdutos);
      if (listaProdutos != null) {
        for (var row in listaProdutos) {
          setState(() {
            produtos.addAll(
                {row['Produto']['NomeProduto']: row['Produto']['IdProduto']});
          });
        }
      }

      print(produtos);
      await Navegar.instance.buscaComandos();
    });
  }

  int apenasNumeros(String idNoText) {
    String soId = idNoText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(soId);
  }

  Future<void> pegaFornecedor() async {
    var lista = [];
    print(produto);
    lista = await crud.selectInner(
        tabela: "FornecedorProduto",
        select:
            'Fornecedor!inner(Pessoa!inner(IdPessoa, Nome)), Produto!inner(IdProduto, NomeProduto)',
        where: {"Produto.IdProduto": produtos[produto]});
    print(lista);
    setState(() {
      lotes.clear();
      fornecedores.clear();
      for (var row in lista) {
        fornecedores.addAll({
          row['Fornecedor']['Pessoa']['Nome']: row['Fornecedor']['Pessoa']
              ['IdPessoa']
        });
      }
    });
  }

  Future<void> pegaLote() async {
    var lista = await crud.selectInner(
        tabela: "FornecedorPLote",
        select:
            '*, Lote!inner(IdLote, NumeroLote), FornecedorProduto!inner(Fornecedor!inner(Pessoa!inner(IdPessoa, Nome)), Produto!inner(IdProduto, NomeProduto))',
        where: {
          "FornecedorProduto.Produto.IdProduto": produtos[produto],
          "FornecedorProduto.Fornecedor.IdFornecedor": fornecedores[fornecedor]
        });
    print(lista);

    for (var row in lista) {
      setState(() {
        lotes.addAll({row['Lote']['NumeroLote']: row['Lote']['IdLote']});
      });
    }
  }

  void resetaValoresCompra() {
    controllersCompra['preco']!.text = "";
    controllersCompra['frete']!.text = "";
    fieldControllerTotal.text = "";
    preco = null;
    frete = null;
  }

  void calculaTotal() {
    if (quantidade != null && preco != null && frete != null) {
      fieldControllerTotal.text = ((quantidade! * preco!) + frete!).toString();
      total = double.parse(fieldControllerTotal.text);
    } else {
      quantidade = 0;
      fieldControllerTotal.text = "";
    }
  }

  Future<void> preencheCamposPF() async {
    var lista = await crud.selectInner(
        tabela: "FornecedorPLote",
        select:
            '*, FornecedorProduto!inner(Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(IdFornecedor))',
        where: {
          "FornecedorProduto.Produto.IdProduto": produtos[produto],
          "FornecedorProduto.Fornecedor.IdFornecedor": fornecedores[fornecedor],
          "IdLote": lotes[lote]
        });
    print(lista);
    for (var row in lista) {
      setState(() {
        controllersCompra['preco']!.text = row['Preco'].toString();
        controllersCompra['frete']!.text = row['Frete'].toString();
        preco = double.parse(controllersCompra['preco']!.text);
        frete = double.parse(controllersCompra['frete']!.text);
      });
    }
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ListView(shrinkWrap: true, children: [
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
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
                      items: produtos.keys.toList().map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          produto = value;
                          fornecedor = null;
                          lote = null;
                          resetaValoresCompra();
                        });

                        await pegaFornecedor();
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: fornecedor,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Fornecedores"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: fornecedores.keys
                          .toList()
                          .map(buildMenuItem)
                          .toList(),
                      onChanged: (value) async {
                        setState(() {
                          fornecedor = value;
                          lote = null;
                          lotes.clear();
                          resetaValoresCompra();
                        });
                        print(fornecedor);
                        await pegaLote();
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: lote,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Número de Lote"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: lotes.keys.toList().map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          lote = value;
                          resetaValoresCompra();
                        });
                        print(lote);
                        await preencheCamposPF();
                        calculaTotal();
                      }),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controllersCompra['qtd']!,
                onChanged: (qtd) {
                  setState(() {
                    if (qtd != '') {
                      quantidade = int.parse(qtd);
                      calculaTotal();
                    } else {
                      setState(() {
                        quantidade = null;
                      });
                    }
                  });
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: "Quantidade",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                enabled: false,
                controller: controllersCompra['preco']!,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Preço",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                enabled: false,
                controller: controllersCompra['frete']!,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Frete",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                enabled: false,
                controller: fieldControllerTotal,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Total",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    print(preCompra);
                    bool isPreechido = true;

                    adicionaPreCompra();

                    setState(() {
                      controllersCompra['qtd']!.text = "";
                      quantidade = null;
                      resetaValoresCompra();
                      fornecedor = null;
                      fornecedores.clear();
                      lotes.clear();
                      produto = null;
                      lote = null;
                    });
                  },
                  child: const Text("Adiciona Linha")),
              ListView(
                shrinkWrap: true,
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: _createColumns(), rows: createRows()))
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    List<Map<dynamic, dynamic>?> dados = vaiComprar();
                    print(dados);

                    var insertCompra =
                        await crud.insert(tabela: 'Compra', map: {
                      'DataCompra':
                          DateFormat.yMMMd().add_Hm().format(DateTime.now()),
                      'HoraCompra': DateFormat.Hms().format(DateTime.now())
                    });
                    print(insertCompra);

                    for (int i = 0; i < dados.length; i++) {
                      var idPF = await crud.select(
                          tabela: 'FornecedorProduto',
                          select: 'IdFornecedorProduto',
                          where: {
                            'IdFornecedor':
                                apenasNumeros(dados[i]!['fornecedor']),
                            'IdProduto': apenasNumeros(dados[i]!['produto']),
                          });
                      print(idPF);
                      var idPFL = await crud.select(
                          tabela: 'FornecedorPLote',
                          select: 'IdFornecedorPLote',
                          where: {
                            'IdFornecedorProduto':
                                idPF[0]!['IdFornecedorProduto'],
                            'IdLote': dados[i]!['lote'],
                          });
                      print(idPFL);
                      await crud.insert(tabela: 'ItemCompra', map: {
                        'IdCompra': insertCompra[0]['IdCompra'],
                        'IdFornecedorPLote': idPFL[0]['IdFornecedorPLote'],
                        'Quantidade': dados[i]!['quantidade'],
                        'PrecoCompra': dados[i]!['preco'],
                        'FreteCompra': dados[i]!['frete']
                      });

                      var estoque = await crud.select(
                          tabela: 'Estoque',
                          select: 'IdEstoque, Quantidade',
                          where: {'IdLote': dados[i]!['lote']});

                      print(estoque);

                      var estoqueUpdate = await crud
                          .update(tabela: 'Estoque', where: {
                        'IdEstoque': estoque[0]['IdEstoque']
                      }, setValue: {
                        'Quantidade':
                            estoque[0]['Quantidade'] + dados[i]!['quantidade']
                      });
                    }

                    setState(() {
                      preCompra.clear();
                      fieldControllerTotal.text = "";
                    });
                  },
                  child: const Text("Comprar"))
            ]))));
  }

  void adicionaPreCompra() {
    bool podeAdicionar = true;
    setState(() {
      for (int i = 0; i < preCompra.length; i++) {
        if (preCompra[i].containsValue(fornecedor) &&
            preCompra[i].containsValue(produto)) {
          podeAdicionar = false;
          break;
        }
      }
      if (podeAdicionar) {
        preCompra.add({
          'produto': produto,
          'fornecedor': fornecedor,
          'lote': lotes[lote],
          'quantidade': quantidade,
          'preco': preco,
          'frete': frete,
          'numerol': lote
        });
        selecionado.add(true);
      }
    });
    print(preCompra);
  }

  List<Map<dynamic, dynamic>?> vaiComprar() {
    List<Map<dynamic, dynamic>?> lista = [];
    for (int i = 0; i < preCompra.length; i++) {
      if (selecionado[i] == true) {
        lista.add(preCompra[i]);
      }
    }
    lista.removeWhere((element) => element == null);
    return lista;
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

  Future<void> selecionaProduto(String item) async {
    List produtosConfere = produtos.keys.toList();
    List pordutosMinisculo =
        produtos.keys.toList().map((produto) => produto.toLowerCase()).toList();
    print(pordutosMinisculo);
    print(item);
    if (pordutosMinisculo.contains(item)) {
      print('Entro');
      setState(() {
        produto = produtosConfere[pordutosMinisculo.indexOf(item)];
        fornecedor = null;
        lote = null;
        resetaValoresCompra();
      });
      await pegaFornecedor();
    } else {
      await Fala.instance.flutterTts.speak('Esse produto não existe');
    }
  }

  Future<void> selecionaFornecedor(String item) async {
    List fornecedorConfere = fornecedores.keys.toList();
    List fornecedorMinisculo = fornecedores.keys
        .toList()
        .map((fornecedor) => fornecedor.toLowerCase())
        .toList();
    print(fornecedorMinisculo);
    print(item);

    if (fornecedorMinisculo.contains(item)) {
      setState(() {
        fornecedor = fornecedorConfere[fornecedorMinisculo.indexOf(item)];
        lote = null;
        lotes.clear();
      });
      resetaValoresCompra();
      await pegaLote();
    } else {
      await Fala.instance.flutterTts.speak('Esse Fornecedor não existe');
    }
  }

  Future<void> selecionaLote(String item) async {
    List loteConfere = lotes.keys.toList();
    if (loteConfere.contains(item)) {
      setState(() {
        lote = item;
        resetaValoresCompra();
      });
      print(lote);
      await preencheCamposPF();
      calculaTotal();
    } else {
      await Fala.instance.flutterTts.speak('Esse Lote não existe');
    }
    print(item);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Voz.instance,
        builder: (context, snapshot) {
          return Scaffold(
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
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
                      await Future.delayed(const Duration(milliseconds: 500));
                      Voz.instance.stopListening();
                      var falou = Voz.instance.lastWords;
                      print(falou);
                      Voz.instance.lastWords = '';

                      var comando = falou
                          .substring(0, falou.indexOf(RegExp(r'[ ]')))
                          .toLowerCase();

                      print(comando);
                      var item = falou
                          .substring(
                              falou.indexOf(RegExp(r'[ ]')) + 1, falou.length)
                          .toLowerCase();

                      if (comando == 'produto'.toLowerCase()) {
                        await selecionaProduto(item);
                      } else if (comando == 'fornecedor'.toLowerCase()) {
                        if (produto == null) {
                          await Fala.instance.flutterTts
                              .speak('Fale um produto primeiro');
                        } else {
                          await selecionaFornecedor(item);
                        }
                      } else if (comando == 'lote'.toLowerCase()) {
                        if (produto == null) {
                          await Fala.instance.flutterTts
                              .speak('Fale um produto primeiro');
                        } else if (fornecedor == null) {
                          await Fala.instance.flutterTts
                              .speak('Fale um fornecedor primeiro');
                        } else {
                          await selecionaLote(item);
                        }
                      } else if (comando == 'quantidade') {
                        String soNum = item.replaceAll(RegExp(r'[^0-9]'), '');
                        if (soNum != '') {
                          setState(() {
                            quantidade = apenasNumeros(item);
                            controllersCompra['qtd']!.text = item;
                            calculaTotal();
                          });
                        } else {
                          setState(() {
                            quantidade = null;
                          });
                          await Fala.instance.flutterTts
                              .speak('Fale um número');
                        }
                      } else {
                        Fala.instance.flutterTts
                            .speak('Esse comando não existe');
                      }
                    }),
                    child: FloatingActionButton(
                        child: const Icon(Icons.hearing),
                        onPressed: () async {}),
                  ),
                  GestureDetector(
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
                      await Future.delayed(const Duration(milliseconds: 750));
                      Voz.instance.stopListening();
                      var tela = Voz.instance.lastWords;
                      Voz.instance.lastWords = '';
                      // ignore: use_build_context_synchronously
                      await Navegar.instance.navegar(tela, context);
                    }),
                    child: FloatingActionButton(
                        child: const Icon(Icons.phone), onPressed: () async {}),
                  ),
                ],
              ),
              drawer: drawerTela.drawerTela(context),
              appBar: AppBar(),
              body: body());
        });
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text('Fornecedor')),
      DataColumn(label: Text('Numero Lote')),
      DataColumn(label: Text('Quantidade')),
      DataColumn(label: Text('Preco')),
      DataColumn(label: Text('Frete')),
      DataColumn(label: Text('Total')),
    ];
  }

  List<DataRow> createRows() {
    return preCompra
        .mapIndexed((index, book) => DataRow(
                cells: [
                  DataCell(Text(book['produto'])),
                  DataCell(Text(book['fornecedor'])),
                  DataCell(Text(book['numerol'])),
                  DataCell(TextFormField(
                    initialValue: "${book['quantidade']}",
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      setState(() {
                        if (text != '') {
                          book['quantidade'] = int.parse(text);
                        } else {
                          book['quantidade'] = 0;
                        }
                      });
                    },
                  )),
                  DataCell(Text("${book['preco']}")),
                  DataCell(Text("${book['frete']}")),
                  DataCell(Text(
                      "${(book['quantidade'] * book['preco']) + book['frete']}"))
                ],
                selected: selecionado[index],
                onSelectChanged: (bool? selected) {
                  setState(() {
                    selecionado[index] = selected!;
                    print(preCompra);
                  });
                }))
        .toList();
  }
}
