import 'package:flutter/material.dart';

import 'DadosDB/crud.dart';
import 'DadosDB/gambiarra.dart';

class NovoLoginPage extends StatefulWidget {
  const NovoLoginPage({Key? key}) : super(key: key);

  @override
  State<NovoLoginPage> createState() => _NovoLoginPageState();
}

class _NovoLoginPageState extends State<NovoLoginPage> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
  }

  var teste = CRUD();

  String usuario = "";
  String senha = "";
  Widget _body() {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.black,
                primaryColorDark: Colors.black,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 400,
                      child: Image.asset('images/Stocker_blue_transp.png')),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (text) {
                      usuario = text;
                    },
                    controller: fieldText,
                    decoration: const InputDecoration(
                      labelText: 'Usuário',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      onChanged: (text) {
                        senha = text;
                      },
                      controller: fieldText2,
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        await teste.updateUL(
                            usuario, senha, Gambiarra.gambiarra.loginAntigo);

                        showDialog(
                          context: context,
                          builder: (_) => alert("Atualização de Login",
                              "Atualizalção feita com sucesso"),
                          barrierDismissible: true,
                        );

                        clearText();
                      },
                      child: const Text('Entrar')),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )));
  }

  Widget alert(String mensagem1, String mensagem2) {
    return AlertDialog(
      title: Text(mensagem1),
      content: Text(mensagem2),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text("Ok"))
      ],
    );
  }

  mensagem(String mensagem1, String mensagem2) {
    return showDialog(
      context: context,
      builder: (_) => alert(mensagem1, mensagem2),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset('images/back2.jpg', fit: BoxFit.cover)),
      _body()
    ]));
  }
}
