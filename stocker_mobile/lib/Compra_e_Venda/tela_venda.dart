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

import 'package:universal_html/html.dart';

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
import '../Validacao_e_Gambiarra/voz.dart';
import '../services/supabase.databaseService.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class Venda extends StatefulWidget {
  const Venda({Key? key}) : super(key: key);

  @override
  State<Venda> createState() => _VendaState();
}

enum TtsState { playing, stopped, paused, continued }

class _VendaState extends State<Venda> {
  var drawerTela = DrawerTela();

  var fieldControllerPreco = TextEditingController();
  var fieldControllerAdicional = TextEditingController();
  var fieldControllerTotal = TextEditingController();
  var fieldControllerQtd = TextEditingController();
  var fieldControllerDesconto = TextEditingController();
  var crud = DataBaseService();
  final produtos = [""];
  final clientes = [""];
  String? produto;
  String? cliente;
  int quantidade = 0;
  double? preco;
  double adicional = 0;
  double? total;
  double desconto = 0;
  int quantidadeLinhas = 0;
  List<bool> selecionado = [];
  List<Map> preVenda = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    produtos.clear();
    clientes.clear();

    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }

      var lista1 = await crud.selectInner(
          tabela: "Estoque",
          select: 'Produto!inner(IdProduto,NomeProduto)PrecoMPM',
          where: {});
      var lista2 = await crud.selectInner(
          tabela: "Cliente", select: 'Pessoa!inner(IdPessoa, Nome)', where: {});

      print(lista1);
      print(lista2);

      setState(() {
        for (var row in lista1) {
          produtos.add(
              "${row['Produto']["IdProduto"]}  ${row["Produto"]["NomeProduto"]}");
        }
        for (var row in lista2) {
          clientes.add("${row['Pessoa']['IdPessoa']} ${row['Pessoa']['Nome']}");
        }
      });
    });
  }

  int apenasNumeros(String idNoText) {
    String soId = idNoText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(soId);
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
                      items: produtos.map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          produto = value;
                          fieldControllerPreco.text = "";
                          cliente = null;
                        });

                        var lista = await crud.selectInner(
                            tabela: "Estoque",
                            select: 'PrecoMPM',
                            where: {
                              "IdProduto": apenasNumeros(produto!),
                            });
                        print(lista);
                        for (var row in lista) {
                          setState(() {
                            fieldControllerPreco.text =
                                row['PrecoMPM'].toString();
                            preco = double.parse(fieldControllerPreco.text);
                          });
                        }
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
                      value: cliente,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Cliente"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: clientes.map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          cliente = value;
                        });
                        var lista = await crud.selectInner(
                            tabela: "Cliente",
                            select: 'Desconto',
                            where: {
                              "IdCliente": apenasNumeros(cliente!),
                            });
                        print(lista);
                        for (var row in lista) {
                          setState(() {
                            fieldControllerDesconto.text =
                                row['Desconto'].toString();
                            desconto =
                                double.parse(fieldControllerDesconto.text);
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
                    if (qtd != "") {
                      quantidade = int.parse(qtd);
                      fieldControllerTotal.text =
                          retornaTotal(quantidade, preco!, adicional, desconto)
                              .toStringAsFixed(2);
                    } else {
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
                controller: fieldControllerAdicional,
                onChanged: (adicional) {
                  setState(() {
                    if (adicional != "") {
                      this.adicional = double.parse(adicional);
                      fieldControllerTotal.text = retornaTotal(
                              quantidade, preco!, this.adicional, desconto)
                          .toStringAsFixed(2);
                    } else {
                      this.adicional = 0;
                      fieldControllerTotal.text = retornaTotal(
                              quantidade, preco!, this.adicional, desconto)
                          .toStringAsFixed(2);
                    }
                  });
                },
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))
                ],
                decoration: InputDecoration(
                    labelText: "Adicional (porcentagem)",
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
                controller: fieldControllerDesconto,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Desconto (porcentagem)",
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
                    print(preVenda);
                    adicionaPreVenda();
                    setState(() {
                      fieldControllerQtd.text = "";
                      fieldControllerAdicional.text = "";
                      fieldControllerTotal.text = "";
                      quantidade = 0;
                      adicional = 0;
                    });
                  },
                  child: const Text("Adiciona Linha")),
              SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                                columns: _createColumns(), rows: createRows())),
                      )
                    ],
                  )),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    print(preVenda);
                    print(selecionado);
                    print(vaiVendar());
                  },
                  child: const Text("Imprimi")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    List<Map<dynamic, dynamic>?> dados = vaiVendar();
                    Map<int, int> vendaCliente = {};

                    if (dados[0] != null) {
                      for (int i = 0; i < dados.length; i++) {
                        if (vendaCliente.isEmpty ||
                            !vendaCliente.containsKey(
                                apenasNumeros(dados[i]!['cliente']))) {
                          var insertVenda =
                              await crud.insert(tabela: 'Venda', map: {
                            'DataVenda': DateFormat.yMMMd()
                                .add_Hm()
                                .format(DateTime.now()),
                            'HoraVenda':
                                DateFormat.Hms().format(DateTime.now()),
                            'IdCliente': apenasNumeros(dados[i]!['cliente'])
                          });
                          print(insertVenda);
                          vendaCliente.addAll({
                            insertVenda[0]['IdCliente']: insertVenda[0]
                                ['IdVenda']
                          });

                          await crud.insert(tabela: 'ItemVenda', map: {
                            'IdVenda': vendaCliente[
                                apenasNumeros(dados[i]!['cliente'])],
                            'IdProduto': apenasNumeros(dados[i]!['produto']),
                            'Quantidade': dados[i]!['quantidade'],
                            'PrecoVenda': dados[i]!['preco'],
                            'Adicional': dados[i]!['adicional'],
                            'DescontoVenda': dados[i]!['desconto']
                          });
                        } else {
                          await crud.insert(tabela: 'ItemVenda', map: {
                            'IdVenda': vendaCliente[
                                apenasNumeros(dados[i]!['cliente'])],
                            'IdProduto': apenasNumeros(dados[i]!['produto']),
                            'Quantidade': dados[i]!['quantidade'],
                            'PrecoVenda': dados[i]!['preco'],
                            'Adicional': dados[i]!['adicional'],
                            'DescontoVenda': dados[i]!['desconto']
                          });
                        }
                        setState(() {
                          preVenda.clear();
                        });
                      }
                    }
                  },
                  child: const Text("Vender"))
            ]))));
  }

  void adicionaPreVenda() {
    bool podeAdicionar = true;
    setState(() {
      for (int i = 0; i < preVenda.length; i++) {
        if (preVenda[i].containsValue(cliente) &&
            preVenda[i].containsValue(produto)) {
          podeAdicionar = false;
          break;
        }
      }

      if (podeAdicionar) {
        preVenda.add({
          'produto': produto,
          'cliente': cliente,
          'quantidade': quantidade,
          'preco': preco,
          'adicional': adicional,
          'desconto': desconto
        });
        selecionado.add(true);
      }
    });
  }

  List<Map<dynamic, dynamic>?> vaiVendar() {
    List<Map<dynamic, dynamic>?> lista = [];
    for (int i = 0; i < preVenda.length; i++) {
      if (selecionado[i] == true) {
        lista.add(preVenda[i]);
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
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.phone),
            onPressed: () async {
              print(this.context);
              Voz.instance.context = this.context;
              await Voz.instance.initSpeechState();

              await Voz.instance.initTts();
              await Voz.instance.buscaComandos();
              Voz.instance.startListening();
            }),
        drawer: drawerTela.drawerTela(context),
        appBar: AppBar(),
        body: body());
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text('Cliente')),
      DataColumn(label: Text('Quantidade')),
      DataColumn(label: Text('Preco')),
      DataColumn(label: Text('Adicional')),
      DataColumn(label: Text('Desconto')),
      DataColumn(label: Text('Total')),
    ];
  }

  double retornaTotal(int qtd, double prec, double adic, double desc) {
    double preTotal = (qtd * prec);
    double preTotalComAdicional = preTotal + (preTotal * (adic / 100));
    double total = preTotalComAdicional - (preTotalComAdicional * (desc / 100));

    return total;
  }

  List<DataRow> createRows() {
    return preVenda
        .mapIndexed((index, book) => DataRow(
                cells: [
                  DataCell(Text(book['produto'])),
                  DataCell(Text(book['cliente'])),
                  DataCell(TextFormField(
                    initialValue: "${book['quantidade']}",
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      setState(() {
                        book['quantidade'] = int.parse(text);
                      });
                    },
                  )),
                  DataCell(Text("${book['preco']}")),
                  DataCell(TextFormField(
                    initialValue: "${book['adicional']}",
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      setState(() {
                        book['adicional'] = int.parse(text);
                      });
                    },
                  )),
                  DataCell(Text("${book['desconto']}")),
                  DataCell(Text(retornaTotal(book['quantidade'], book['preco'],
                          book['adicional'], book['desconto'])
                      .toStringAsFixed(2)))
                ],
                selected: selecionado[index],
                onSelectChanged: (bool? selected) {
                  setState(() {
                    selecionado[index] = selected!;
                    print(preVenda);
                  });
                }))
        .toList();
  }
}
