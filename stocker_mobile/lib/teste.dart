import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocker_mobile/app/providers/app.authentication.dart';
import 'package:stocker_mobile/app/providers/app.dbnotifier.dart';

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  State<Teste> createState() => _TesteState();
}

// ; : "" []
class _TesteState extends State<Teste> {
  String nome = "Hiury";
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  ScaffoldFeatureController mensagem(var context, var response) {
    return response.error == null
        ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Cadastro feito com Sucesso!: Email de Confirmação eviado")))
        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Erro no Cadastro: ${response.error!.message.toString()}")));
  }

  @override
  Widget build(BuildContext context) {
    final DataBaseNotifier authDBNotifier =
        Provider.of<DataBaseNotifier>(context, listen: false);
    final AuthenticationNotifier authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    return Scaffold(
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
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

                      authDBNotifier.insert(tabela: "Teste", map: dataMap);
                    },
                    child: const Text("Manda pro banco")),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () async {
                      var lista = [];
                      Map<String, dynamic> where = {};

                      List<String> colunas = ["nome", "numero"];
                      List<dynamic> valores = ["Mito (contem ironia)", 17];

                      where = Map.fromIterables(colunas, valores);
                      print(where);
                      lista = await authDBNotifier.select(
                          tabela: "Teste", select: "*", where: where);

                      print(lista);

                      for (var row in lista) {
                        setState(() {
                          nome = row['nome'];
                        });
                      }
                    },
                    child: const Text("pega do Banco e poem no nome")),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () async {
                      var lista = [];
                      Map<String, dynamic> where = {};
                      Map<String, dynamic> setValue = {};

                      List<String> colunas = ["nome", "numero"];
                      List<dynamic> valores = ["Mito (contem ironia)", 13];

                      where = Map.fromIterables(colunas, valores);

                      List<String> colunasAlterar = ["nome", "numero"];
                      List<dynamic> valorAlterar = ["Hiury Foda", 21];

                      setValue =
                          Map.fromIterables(colunasAlterar, valorAlterar);

                      print(where);
                      await authDBNotifier.update(
                          tabela: "Teste", where: where, setValue: setValue);
                    },
                    child: const Text("Atualiza Banco")),
                const SizedBox(height: 15),
                Text("$nome"),
                TextField(
                  controller: fieldText,
                  decoration: const InputDecoration(label: Text("Email")),
                ),
                TextField(
                  controller: fieldText2,
                  decoration: const InputDecoration(label: Text("Senha")),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await authNotifier.signUp(
                          context: context,
                          email: fieldText.text,
                          senha: fieldText2.text);
                    },
                    child: const Text("Cadastrar usuario")),
                const SizedBox(height: 15),
                ElevatedButton(
                    onPressed: () async {
                      Map<String, dynamic> where = {};
                      Map<String, dynamic> setValue = {};

                      List<String> colunas = ["nome", "numero"];
                      List<dynamic> valores = ["Mito (contem ironia)", 13];

                      where = Map.fromIterables(colunas, valores);
                      await authDBNotifier.delete(
                          tabela: "Teste", where: where);
                    },
                    child: const Text("Deleta linhas")),
              ])),
            )));
  }
}
