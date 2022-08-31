import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocker_mobile/app/providers/app.dbnotifier.dart';

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  State<Teste> createState() => _TesteState();
}

// ; : "" []
class _TesteState extends State<Teste> {
  String nome = "Hiury";

  @override
  Widget build(BuildContext context) {
    final DataBaseNotifier authNotifier =
        Provider.of<DataBaseNotifier>(context, listen: false);

    return Scaffold(
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Center(
                child: ListView(shrinkWrap: true, children: [
              const Center(child: Text("Funfa")),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    Map<String, dynamic> dataMap = {};

                    List<String> colunas = ["nome", "numero"];
                    List<dynamic> valores = ["Mito (contem ironia)", 13];

                    dataMap = Map.fromIterables(colunas, valores);
                    print(dataMap);

                    authNotifier.insert(tabela: "Teste", map: dataMap);
                  },
                  child: const Text("Manda pro banco")),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    var lista = [];
                    Map<String, dynamic> query = {};

                    List<String> colunas = ["nome", "numero"];
                    List<dynamic> valores = ["Mito (contem ironia)", 13];

                    query = Map.fromIterables(colunas, valores);
                    print(query);
                    lista = await authNotifier.select(
                        tabela: "Teste", query: query);

                    print(lista);

                    for (var row in lista) {
                      setState(() {
                        nome = row['nome'];
                      });
                    }
                  },
                  child: const Text("pega do Banco")),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () async {
                    var lista = [];
                    Map<String, dynamic> query = {};
                    Map<String, dynamic> alteracoes = {};

                    List<String> colunas = ["nome", "numero"];
                    List<dynamic> valores = ["Mito (contem ironia)", 13];

                    query = Map.fromIterables(colunas, valores);

                    List<String> colunasAlterar = ["nome", "numero"];
                    List<dynamic> valorAlterar = ["Hiury Foda", 21];

                    alteracoes =
                        Map.fromIterables(colunasAlterar, valorAlterar);

                    print(query);
                    await authNotifier.update(
                        tabela: "Teste", query: query, alteracoes: alteracoes);
                  },
                  child: const Text("pega do Banco")),
              const SizedBox(height: 15),
              Text("$nome"),
            ]))));
  }
}
