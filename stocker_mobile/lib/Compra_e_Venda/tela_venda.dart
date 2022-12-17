import 'dart:io' as plataforma;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:universal_html/html.dart' as html;

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
import '../Validacao_e_Gambiarra/falapratexto.dart';
import '../Validacao_e_Gambiarra/textoprafala.dart';
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

  Map<String, int> clientes = {};
  String? produto;
  String? cliente;
  int? quantidade;
  double? preco;
  double adicional = 0;
  double? total;
  double desconto = 0;
  int quantidadeLinhas = 0;
  List<bool> selecionado = [];
  List<Map> preVenda = [];
  bool valor = false;
  bool valor2 = false;
  bool valor3 = false;
  bool valor4 = false;
  String? lote;
  Map<String, int> lotes = {};
  Map<String, int> produtos = {};
  int count = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    produtos.clear();
    clientes.clear();

    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await html.window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }

      var lista1 =
          await crud.selectInner(tabela: "Produto", select: '*', where: {});
      var lista2 = await crud.selectInner(
          tabela: "Cliente", select: 'Pessoa!inner(IdPessoa, Nome)', where: {});

      print(lista1);
      print(lista2);

      setState(() {
        for (var row in lista1) {
          produtos.addAll({row['NomeProduto']: row['IdProduto']});
        }
        for (var row in lista2) {
          clientes.addAll({row['Pessoa']['Nome']: row['Pessoa']['IdPessoa']});
        }
      });
      await Navegar.instance.buscaComandos();
    });
  }

  int apenasNumeros(String idNoText) {
    String soId = idNoText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(soId);
  }

  calculaTotal() {
    if (fieldControllerQtd.text != "" &&
        fieldControllerAdicional.text != "" &&
        fieldControllerPreco.text != "" &&
        fieldControllerDesconto.text != "") {
      quantidade = int.parse(fieldControllerQtd.text);
      adicional = double.parse(fieldControllerAdicional.text);
      setState(() {
        fieldControllerTotal.text = retornaTotal(
                int.parse(fieldControllerQtd.text),
                double.parse(fieldControllerPreco.text),
                double.parse(fieldControllerAdicional.text),
                double.parse(fieldControllerDesconto.text))
            .toString();
        total = double.parse(fieldControllerTotal.text);
      });
    } else {
      fieldControllerTotal.text = "";
    }
  }

  Widget body(int tamanhoMap, Map<String, String> palavras) {
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
                          fieldControllerPreco.text = "";
                          cliente = null;
                        });
                        var lista = await crud.selectInner(
                            tabela: 'Estoque',
                            select: 'Lote!inner(*, IdProduto)',
                            where: {'Lote.IdProduto': produtos[produto]});
                        print(lista);
                        for (var row in lista) {
                          setState(() {
                            lotes.addAll({
                              row['Lote']['NumeroLote']: row['Lote']['IdLote']
                            });
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
                      value: lote,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Lotes"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: lotes.keys.toList().map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          lote = value;
                          fieldControllerPreco.text = "";
                          cliente = null;
                        });

                        var lista = await crud.selectInner(
                            tabela: "Estoque",
                            select: 'PrecoMPM',
                            where: {
                              "IdLote": lotes[lote],
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
                      items: clientes.keys.toList().map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          cliente = value;
                        });
                        var lista = await crud.selectInner(
                            tabela: "Cliente",
                            select: 'Desconto',
                            where: {
                              "IdCliente": clientes[cliente],
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
                          retornaTotal(quantidade!, preco!, adicional, desconto)
                              .toStringAsFixed(2);
                    } else {
                      fieldControllerTotal.text = "";
                      quantidade = null;
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
                  if (Voz.instance.palavrasVenda.containsKey('adicional')) {
                    Voz.instance.palavrasVenda.remove('adicional');
                  }
                  setState(() {
                    if (adicional != "") {
                      this.adicional = double.parse(adicional);
                      fieldControllerTotal.text = retornaTotal(
                              quantidade!, preco!, this.adicional, desconto)
                          .toStringAsFixed(2);
                    } else {
                      this.adicional = 0;
                      fieldControllerTotal.text = retornaTotal(
                              quantidade!, preco!, this.adicional, desconto)
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
                      fieldControllerPreco.text = "";
                      produto = null;
                      preco = 0;
                      fieldControllerDesconto.text = "";
                      lotes.clear();
                      lote = null;
                      cliente = null;
                      desconto = 0;

                      quantidade = 0;
                      adicional = 0;
                    });

                    if (Voz.instance.palavrasCompra.isNotEmpty) {
                      Voz.instance.palavrasCompra.clear();
                    }
                  },
                  child: const Text("Adiciona Linha")),
              ListView(
                shrinkWrap: true,
                children: [
                  Center(
                    child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            columns: _createColumns(), rows: createRows())),
                  )
                ],
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    List<Map<dynamic, dynamic>?> dados = vaiVendar();
                    Map<int, int> vendaCliente = {};

                    if (dados[0] != null) {
                      for (int i = 0; i < dados.length; i++) {
                        var qtdEstoque = await crud.select(
                            tabela: 'Estoque',
                            select: 'IdEstoque, Quantidade',
                            where: {'IdLote': dados[i]!['idLote']});
                        print(qtdEstoque);
                        if (qtdEstoque[0]['Quantidade'] >
                            dados[i]!['quantidade']) {
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
                              'IdLote': dados[i]!['idLote'],
                              'Quantidade': dados[i]!['quantidade'],
                              'PrecoVenda': dados[i]!['preco'],
                              'Adicional': dados[i]!['adicional'],
                              'DescontoVenda': dados[i]!['desconto']
                            });
                            var estoqueUpdate = await crud.update(
                                tabela: 'Estoque',
                                where: {
                                  'IdEstoque': qtdEstoque[0]['IdEstoque']
                                },
                                setValue: {
                                  'Quantidade': qtdEstoque[0]['Quantidade'] -
                                      dados[i]!['quantidade']
                                });
                          } else {
                            await crud.insert(tabela: 'ItemVenda', map: {
                              'IdVenda': vendaCliente[
                                  apenasNumeros(dados[i]!['cliente'])],
                              'IdLote': dados[i]!['idLote'],
                              'Quantidade': dados[i]!['quantidade'],
                              'PrecoVenda': dados[i]!['preco'],
                              'Adicional': dados[i]!['adicional'],
                              'DescontoVenda': dados[i]!['desconto']
                            });
                            var estoqueUpdate = await crud.update(
                                tabela: 'Estoque',
                                where: {
                                  'IdEstoque': qtdEstoque[0]['IdEstoque']
                                },
                                setValue: {
                                  'Quantidade': qtdEstoque[0]['Quantidade'] -
                                      dados[i]!['quantidade']
                                });
                          }
                        } else {
                          var snackBar = SnackBar(
                            content: Text(
                                'A venda ${dados[i]!['id']} não pode ser completa por falta de produto'),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }

                        setState(() {
                          preVenda.clear();
                          count = 1;
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
          'id': count,
          'produto': produto,
          'lote': lote,
          'idLote': lotes[lote],
          'cliente': cliente,
          'quantidade': quantidade,
          'preco': preco,
          'adicional': adicional,
          'desconto': desconto
        });
        selecionado.add(true);
        setState(() {
          count++;
        });
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
                          valor4 = true;
                        });
                        print(this.context);
                        Voz.instance.opcao = 2;
                        Voz.instance.context = this.context;

                        Voz.instance.startListening();
                      }),
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
                      await Future.delayed(Duration(milliseconds: 500));
                      Voz.instance.stopListening();
                      var tela = Voz.instance.lastWords;
                      Voz.instance.lastWords = '';
                      // ignore: use_build_context_synchronously
                      await Navegar.instance.navegar(tela, context);
                    }),
                    child: FloatingActionButton(
                        child: Icon(Icons.phone), onPressed: () async {}),
                  ),
                ],
              ),
              drawer: drawerTela.drawerTela(context),
              appBar: AppBar(),
              body: body(Voz.instance.palavrasVenda.length,
                  Voz.instance.palavrasVenda));
        });
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text("Id")),
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text("Número Lote")),
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
                  DataCell(Text(book['id'].toString())),
                  DataCell(Text(book['produto'])),
                  DataCell(Text(book['lote'])),
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
