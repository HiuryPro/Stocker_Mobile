import 'package:flutter/material.dart';
import 'package:stocker_mobile/DadosDB/gambiarra.dart';

import 'DadosDB/dados.dart';

class NovoLoginPage extends StatefulWidget {
  const NovoLoginPage({Key? key}) : super(key: key);

  @override
  State<NovoLoginPage> createState() => _NovoLoginPageState();
}

class _NovoLoginPageState extends State<NovoLoginPage> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  var teste = Dados();

  String usuario = '';
  String senha = '';

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
  }

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
                        await teste.atualizaLogin(
                            usuario, senha, Gambiarra.gambiarra.loginAntigo);

                        showDialog(
                          context: context,
                          builder: (_) => alert(),
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

  Widget alert() {
    return AlertDialog(
      title: const Text("Atualização"),
      content: const Text("Atualização de login e senha feito com sucesso!"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text("Ok"))
      ],
    );
  }
}
