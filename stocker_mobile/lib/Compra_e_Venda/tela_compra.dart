import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/voz.dart';

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
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

  @override
  void initState() {
    super.initState();
    produtos.clear();
    Future.delayed(Duration.zero, () async {
      var lista = await crud.selectInner(
          tabela: "FornecedorProduto",
          select:
              'Preco, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(IdFornecedor, NomeFornecedor)',
          where: {});
      if (lista != null) {
        setState(() {
          for (var row in lista) {
            produtos.add(
                "${row["Produto"]["IdProduto"]}  ${row["Produto"]["NomeProduto"]}");
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

                        lista = await crud.selectInner(
                            tabela: "FornecedorProduto",
                            select:
                                'Fornecedor!inner(IdFornecedor, NomeFornecedor), Produto!inner(IdProduto, NomeProduto)',
                            where: {
                              "Produto.IdProduto": int.parse(produto![0])
                            });
                        setState(() {
                          fornecedores.clear();
                          for (var row in lista) {
                            fornecedores.add(
                                "${row["Fornecedor"]["IdFornecedor"]} ${row['Fornecedor']['NomeFornecedor']}");
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
                    if (qtd != "") {
                      quantidade = int.parse(qtd);
                      fieldControllerTotal.text =
                          ((quantidade! * preco!) + frete!).toString();
                      total = double.parse(fieldControllerTotal.text);
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
    return Scaffold(
        floatingActionButton: const ReconheceVoz(),
        drawer: drawerTela.drawerTela(context),
        appBar: AppBar(),
        body: body());
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
                        book['quantidade'] = int.parse(text);
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
