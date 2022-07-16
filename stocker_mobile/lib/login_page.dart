import 'package:flutter/material.dart';
import 'package:stocker_mobile/DadosDB/gambiarra.dart';

import 'DadosDB/dados.dart';
import 'on_hover.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  var teste = Dados();

  String usuario = '';
  String senha = '';
  int id = 0;

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
  }

  Future<bool> autorizaLogin() async {
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.pegaUsuario();

    for (int i = 0; i < listaU.length; i = i + 4) {
      if (usuario == listaU[i + 1] && senha == listaU[i + 2]) {
        autoriza = Future<bool>.value(true);
      }
    }
    return autoriza;
  }

  Future<bool> novoLogin() async {
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.pegaUsuario();

    for (int i = 0; i < listaU.length; i = i + 4) {
      if (usuario == listaU[i + 1] && senha == listaU[i + 2]) {
        print(listaU[i + 3]);
        if (listaU[i + 3] == 0) {
          autoriza = Future<bool>.value(true);
          id = listaU[i];
        }
      }
    }
    return autoriza;
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
                        if (await autorizaLogin()) {
                          if (await novoLogin()) {
                            Navigator.of(context).pushNamed("/novologinpage");
                            Gambiarra.gambiarra.mudaLogin(id);
                          } else {
                            Navigator.of(context).pushNamed("/homepage");
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (_) => alert(),
                            barrierDismissible: true,
                          );
                        }
                        clearText();
                      },
                      child: const Text('Entrar')),
                  const SizedBox(
                    height: 20,
                  ),
                  OnHover(builder: (isHovered) {
                    final color = isHovered ? Colors.blue : Colors.black;
                    return GestureDetector(
                      child: Text("Esqueci minha Senha ?",
                          style: TextStyle(color: color)),
                    );
                  }),
                  const SizedBox(
                    height: 20,
                  ),
                  OnHover(builder: (isHovered) {
                    final color = isHovered ? Colors.blue : Colors.black;
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed("/cadpage");
                      },
                      child: Text("Ainda não é cadastrado ?",
                          style: TextStyle(color: color)),
                    );
                  }),
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
      title: const Text("Login Invalido"),
      content: const Text("Usuário/senha incorretos"),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"))
      ],
    );
  }
}
