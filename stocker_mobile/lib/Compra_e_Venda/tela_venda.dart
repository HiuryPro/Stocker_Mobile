import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../Validacao_e_Gambiarra/app_controller.dart';
import '../services/supabase.databaseService.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class Venda extends StatefulWidget {
  const Venda({Key? key}) : super(key: key);

  @override
  State<Venda> createState() => _VendaState();
}

class _VendaState extends State<Venda> {
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
  int? quantidade;
  double? preco;
  double adicional = 0;
  double? total;
  double desconto = 0;
  int quantidadeLinhas = 0;
  List<bool> selecionado = [];
  List<Map> preVenda = [];

  @override
  void initState() {
    super.initState();
    produtos.clear();
    clientes.clear();
    Future.delayed(Duration.zero, () async {
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
                      double preTotal = (quantidade! * preco!);
                      double preTotalComAdicional =
                          preTotal + (preTotal * (this.adicional / 100));
                      double total = preTotalComAdicional -
                          (preTotalComAdicional * (desconto / 100));
                      fieldControllerTotal.text = total.toStringAsFixed(2);
                      total = double.parse(fieldControllerTotal.text);
                    } else {
                      fieldControllerTotal.text = "";
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
                    });
                  },
                  child: const Text("Adiciona Linha")),
              DataTable(columns: _createColumns(), rows: createRows()),
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
                    var insertVenda = await crud.insert(tabela: 'Venda', map: {
                      'DataVenda':
                          DateFormat.yMMMd().add_Hm().format(DateTime.now()),
                      'HoraVenda': DateFormat.Hms().format(DateTime.now())
                    });
                    for (int i = 0; i < dados.length; i++) {
                      var id = await crud.select(
                          tabela: 'clienteProduto',
                          select: 'IdclienteProduto',
                          where: {
                            'Idcliente':
                                int.parse(dados[i]!['cliente'].substring(0, 1)),
                            'IdProduto':
                                int.parse(dados[i]!['produto'].substring(0, 1))
                          });
                      await crud.insert(tabela: 'ItemVenda', map: {
                        'IdVenda': insertVenda[0]['IdVenda'],
                        'IdclienteProduto': id[0]['IdclienteProduto'],
                        'Quantidade': dados[i]!['quantidade'],
                        'PrecoVenda': dados[i]!['preco'],
                        'adicionalVenda': dados[i]!['adicional']
                      });
                    }
                    setState(() {
                      preVenda.clear();
                    });
                  },
                  child: const Text("Vendar"))
            ]))));
  }

  void adicionaPreVenda() {
    setState(() {
      preVenda.add({
        'produto': produto,
        'cliente': cliente,
        'quantidade': quantidade,
        'preco': preco,
        'adicional': adicional,
        'desconto': desconto
      });
      selecionado.add(true);
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
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/homepage', (Route<dynamic> route) => false);
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                      style: TextStyle(color: AppController.instance.theme1),
                      "BlackTheme"),
                  Switch(
                    value: AppController.instance.isDarkTheme,
                    onChanged: (value) {
                      setState(() {
                        AppController.instance.changeTheme();
                      });
                    },
                  ),
                ],
              ),
            ]),
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
                  DataCell(Text("${book['adicional']}")),
                  DataCell(Text("${book['desconto']}")),
                  DataCell(Text(
                      "${(book['quantidade'] * book['preco']) + book['adicional']}"))
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
