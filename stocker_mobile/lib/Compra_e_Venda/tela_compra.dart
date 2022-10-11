import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../DadosDB/crud.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../services/supabase.databaseService.dart';

class Compra extends StatefulWidget {
  const Compra({Key? key}) : super(key: key);

  @override
  State<Compra> createState() => _CompraState();
}

class _CompraState extends State<Compra> {
  var fieldControllerPreco = TextEditingController();
  var fieldControllerTotal = TextEditingController();
  var crud = DataBaseService();
  final produtos = [""];
  final fornecedores = [""];
  String? produto;
  String? fornecedor;
  int? quantidade;
  double? preco;
  double? total;
  int quantidadeLinhas = 0;
  List<bool> selecionado = [];

  List<DataRow> linhas = [];
  List<DataColumn> colunas = const [
    DataColumn(label: Text("Produto")),
    DataColumn(label: Text("Fornecedor")),
    DataColumn(label: Text("Preco")),
    DataColumn(label: Text("Quantidade")),
    DataColumn(label: Text("Frete")),
    DataColumn(label: Text("Data da Compra")),
    DataColumn(label: Text("Hora da Compra")),
  ];

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

      setState(() {
        for (var row in lista) {
          produtos.add(
              "${row["Produto"]["IdProduto"]}  ${row["Produto"]["NomeProduto"]}");
        }
      });
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
                        var lista;
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
                                'Preco, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(IdFornecedor)',
                            where: {
                              "Produto.IdProduto": int.parse(produto![0]),
                              "Fornecedor.IdFornecedor":
                                  int.parse(fornecedor![0])
                            });
                        print(lista);
                        for (var row in lista) {
                          setState(() {
                            fieldControllerPreco.text = row['Preco'].toString();
                            preco = double.parse(fieldControllerPreco.text);
                          });
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (qtd) {
                  setState(() {
                    if (qtd != "") {
                      quantidade = int.parse(qtd);
                      fieldControllerTotal.text =
                          (quantidade! * preco!).toString();
                    } else {
                      fieldControllerTotal.text = "";
                    }
                  });
                },
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
              SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Center(
                        child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: colunas,
                              rows: linhas,
                              showCheckboxColumn: true,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () {
// cadastar compra
                    adicionaLinhaTabela();
                  },
                  child: Text("Comprar"))
            ]))));
  }

  adicionaLinhaTabela() {
    var data = DateFormat("dd/MM/yyyy").format(DateTime.now());
    var hora = DateFormat.Hms().format(DateTime.now());
    setState(() {
      selecionado.add(false);

      linhas.add(DataRow(
          selected: selecionado[quantidadeLinhas],
          onSelectChanged: ((bool? value) {
            setState(() {
              selecionado[quantidadeLinhas] = value!;
            });
          }),
          cells: [
            const DataCell(Text("Maçã")),
            const DataCell(Text("Mario")),
            const DataCell(Text("5")),
            const DataCell(Text("10")),
            const DataCell(Text("2")),
            DataCell(Text(data)),
            DataCell(Text(hora))
          ]));
      quantidadeLinhas++;
    });
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
}
