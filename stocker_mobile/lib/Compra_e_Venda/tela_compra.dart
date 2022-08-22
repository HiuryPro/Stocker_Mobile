import 'package:flutter/material.dart';

import '../DadosDB/crud.dart';

class Compra extends StatefulWidget {
  const Compra({Key? key}) : super(key: key);

  @override
  State<Compra> createState() => _CompraState();
}

class _CompraState extends State<Compra> {
  final produtos = ["teste", "teste2"];
  final fornecedores = [
    "vai",
    "come",
    "vb",
    "bbbc",
    "vsbbj",
    "sfhsuf",
    "uahhsf",
    "hfsjfsjkfhjks",
    "shfshfsj"
  ];
  String? produto;
  String? fornecedor;
  var db = CRUD();

  @override
  void initState() {
    super.initState();
    produtos.clear();
    Future.delayed(Duration.zero, () async {
      var result = await db.select("SELECT *  FROM produto");

      for (var row in result) {
        setState(() {
          produtos.add(row['nome']);
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
                      disabledHint: const Padding(
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
                          fornecedor = null;
                        });

                        lista = await db.select(
                            "SELECT *  FROM fornecedor_produto where produto = '$produto'");
                        setState(() {
                          fornecedores.clear();
                          for (var row in lista) {
                            fornecedores.add(row['fornecedor']);
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
                      disabledHint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Fornecedores"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: fornecedores.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(() {
                          fornecedor = value;
                        });
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Produto",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Produto",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
            ]))));
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
    return Scaffold(body: body());
  }
}
