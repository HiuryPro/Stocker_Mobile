import 'dart:io' as plataforma;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:universal_html/html.dart';
import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
import '../Validacao_e_Gambiarra/voz.dart';
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

  var fieldControllerPreco = TextEditingController();
  var fieldControllerFrete = TextEditingController();
  var fieldControllerTotal = TextEditingController();
  var fieldControllerQtd = TextEditingController();
  var crud = DataBaseService();
  final produtos = [""];
  final fornecedores = [""];
  String? produto;
  String? fornecedor;
  int? quantidade;
  double? preco;
  double? frete;
  double? total;
  int quantidadeLinhas = 0;
  List<bool> selecionado = [];
  List<Map> preCompra = [];

  bool valor = true;
  bool valor2 = true;
  bool valor3 = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    produtos.clear();
    print('Funciona inferno');
    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }

      var lista = await crud.selectInner(
          tabela: "FornecedorProduto",
          select:
              'Preco, Frete, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(Pessoa!inner(IdPessoa, Nome))',
          where: {});
      print(lista);
      if (lista != null) {
        setState(() {
          for (var row in lista) {
            produtos.add(
                "${row["Produto"]["IdProduto"]} ${row["Produto"]["NomeProduto"]}");
          }
        });
      }
    });
  }

  int apenasNumeros(String idNoText) {
    String soId = idNoText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(soId);
  }

  adicionaF(var palavras) async {
    var lista = [];

    print(palavras['produto']);
    print(apenasNumeros(palavras['produto']!));
    lista = await crud.selectInner(
        tabela: "FornecedorProduto",
        select:
            'Fornecedor!inner(Pessoa!inner(IdPessoa, Nome)), Produto!inner(IdProduto, NomeProduto)',
        where: {"Produto.IdProduto": apenasNumeros(palavras['produto']!)});
    setState(() {
      valor = false;
      fieldControllerPreco.text = "";
      produto = palavras['produto'];
      fornecedor = null;
      fornecedores.clear();
      for (var row in lista) {
        fornecedores.add(
            "${row['Fornecedor']['Pessoa']['IdPessoa']} ${row['Fornecedor']['Pessoa']['Nome']}");
      }
    });
  }

  adicionaPreco(var palavras) async {
    var lista = await crud.selectInner(
        tabela: "FornecedorProduto",
        select:
            '*, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(IdFornecedor)',
        where: {
          "Produto.IdProduto": apenasNumeros(palavras['produto']),
          "Fornecedor.IdFornecedor": apenasNumeros(palavras['fornecedor'])
        });
    print(lista);
    for (var row in lista) {
      setState(() {
        valor2 = false;
        fornecedor = palavras['fornecedor'];
        fieldControllerPreco.text = row['Preco'].toString();
        fieldControllerFrete.text = row['Frete'].toString();
        preco = double.parse(fieldControllerPreco.text);
        frete = double.parse(fieldControllerFrete.text);
        calculaTotal();
      });
    }
  }

  adicionaQtd(var palavras) async {
    setState(() {
      valor3 = false;
    });

    if (palavras['quantidade']!.contains(RegExp(r'[A-Za-z]'))) {
      await Voz.instance
          .mensagem('Erro ao gravar Quantidade. Tente falar novamente');
      Voz.instance.palavrasCompra.remove('quantidade');
    } else {
      fieldControllerQtd.text = palavras['quantidade']!;
      calculaTotal();
    }
  }

  calculaTotal() {
    if (fieldControllerQtd.text != "" &&
        fieldControllerFrete.text != "" &&
        fieldControllerPreco.text != "") {
      quantidade = int.parse(fieldControllerQtd.text);
      setState(() {
        fieldControllerTotal.text =
            ((quantidade! * preco!) + frete!).toString();
        total = double.parse(fieldControllerTotal.text);
      });
    } else {
      fieldControllerTotal.text = "";
    }
  }

  Widget body(int lastWords, Map<String, String> palavras) {
    Future.delayed(Duration.zero, () async {
      if (palavras.containsKey('produto') &&
          !palavras.containsKey('fornecedor') &&
          valor) {
        produto = palavras['produto'];
        await adicionaF(palavras);
      }

      if (palavras.containsKey('fornecedor') &&
          palavras.containsKey('produto') &&
          valor2) {
        fornecedor = palavras['fornecedor'];
        await adicionaPreco(palavras);
      }

      if (palavras.containsKey('quantidade') && valor3) {
        await adicionaQtd(palavras);
      }
    });

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ListView(shrinkWrap: true, children: [
              Text(palavras.toString()),
              SizedBox(height: 15),
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
                      items: produtos.map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        var lista = [];
                        setState(() {
                          produto = value;

                          fieldControllerPreco.text = "";
                          fornecedor = null;
                        });
                        print(produto);
                        lista = await crud.selectInner(
                            tabela: "FornecedorProduto",
                            select:
                                'Fornecedor!inner(Pessoa!inner(IdPessoa, Nome)), Produto!inner(IdProduto, NomeProduto)',
                            where: {
                              "Produto.IdProduto": apenasNumeros(produto!)
                            });
                        setState(() {
                          fornecedores.clear();
                          for (var row in lista) {
                            fornecedores.add(
                                "${row['Fornecedor']['Pessoa']['IdPessoa']} ${row['Fornecedor']['Pessoa']['Nome']}");
                          }
                        });
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
                      items: fornecedores.map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          fornecedor = value;
                        });
                        print(fornecedor);
                        var lista = await crud.selectInner(
                            tabela: "FornecedorProduto",
                            select:
                                '*, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(IdFornecedor)',
                            where: {
                              "Produto.IdProduto": int.parse(produto![0]),
                              "Fornecedor.IdFornecedor":
                                  int.parse(fornecedor![0])
                            });
                        print(lista);
                        for (var row in lista) {
                          setState(() {
                            fieldControllerPreco.text = row['Preco'].toString();
                            fieldControllerFrete.text = row['Frete'].toString();
                            preco = double.parse(fieldControllerPreco.text);
                            frete = double.parse(fieldControllerFrete.text);
                          });
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                controller: fieldControllerQtd,
                onChanged: (qtd) {
                  setState(() {
                    if (Voz.instance.palavrasCompra.containsKey('quantidade')) {
                      Voz.instance.palavrasCompra.remove('quantidade');
                    }

                    if (qtd != "") {
                      quantidade = int.parse(qtd);
                      fieldControllerTotal.text =
                          ((quantidade! * preco!) + frete!).toString();
                      total = double.parse(fieldControllerTotal.text);
                    } else {
                      quantidade = 0;
                      fieldControllerTotal.text = "";
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
                controller: fieldControllerPreco,
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
                controller: fieldControllerFrete,
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
                  onPressed: () {
                    print(preCompra);
                    adicionaPreCompra();

                    setState(() {
                      fieldControllerQtd.text = "";
                      fieldControllerTotal.text = "";
                      fieldControllerFrete.text = "";
                      fieldControllerPreco.text = "";
                      fornecedor = null;
                      produto = null;
                    });

                    if (Voz.instance.palavrasCompra.isNotEmpty) {
                      Voz.instance.palavrasCompra.clear();
                    }
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
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    print(preCompra);
                    print(selecionado);
                    print(vaiComprar());
                  },
                  child: const Text("Imprimi")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    List<Map<dynamic, dynamic>?> dados = vaiComprar();
                    var insertCompra =
                        await crud.insert(tabela: 'Compra', map: {
                      'DataCompra':
                          DateFormat.yMMMd().add_Hm().format(DateTime.now()),
                      'HoraCompra': DateFormat.Hms().format(DateTime.now())
                    });
                    for (int i = 0; i < dados.length; i++) {
                      var id = await crud.select(
                          tabela: 'FornecedorProduto',
                          select: 'IdFornecedorProduto',
                          where: {
                            'IdFornecedor': int.parse(
                                dados[i]!['fornecedor'].substring(0, 1)),
                            'IdProduto':
                                int.parse(dados[i]!['produto'].substring(0, 1))
                          });
                      await crud.insert(tabela: 'ItemCompra', map: {
                        'IdCompra': insertCompra[0]['IdCompra'],
                        'IdFornecedorProduto': id[0]['IdFornecedorProduto'],
                        'Quantidade': dados[i]!['quantidade'],
                        'PrecoCompra': dados[i]!['preco'],
                        'FreteCompra': dados[i]!['frete']
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
          'quantidade': quantidade,
          'preco': preco,
          'frete': frete
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

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Voz.instance,
        builder: (context, snapshot) {
          return Scaffold(
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      heroTag: null,
                      child: Icon(Icons.hearing),
                      onPressed: () async {
                        setState(() {
                          valor = true;
                          valor2 = true;
                          valor3 = true;
                        });
                        print(this.context);
                        Voz.instance.opcao = 1;
                        Voz.instance.context = this.context;
                        await Voz.instance.initSpeechState();
                        await Voz.instance.initTts();
                        await Voz.instance.buscaComandos();
                        Voz.instance.startListening();
                      }),
                  FloatingActionButton(
                      heroTag: null,
                      child: Icon(Icons.phone),
                      onPressed: () async {
                        print(this.context);
                        Voz.instance.context = this.context;
                        Voz.instance.opcao = 0;
                        await Voz.instance.initSpeechState();

                        await Voz.instance.initTts();
                        await Voz.instance.buscaComandos();
                        Voz.instance.startListening();
                      })
                ],
              ),
              drawer: drawerTela.drawerTela(context),
              appBar: AppBar(),
              body: body(Voz.instance.palavrasCompra.length,
                  Voz.instance.palavrasCompra));
        });
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text('Fornecedor')),
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
