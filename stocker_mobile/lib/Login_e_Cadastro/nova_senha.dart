import 'dart:math';

import 'package:flutter/material.dart';
import '../DadosDB/crud.dart';
import '../SendEmail/send_email.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key}) : super(key: key);

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  var teste = CRUD();
  var sendMail = SendMail();

  String email = '';

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
                  const Text(
                      "Informe o email que está vinculado a seu cadastrado \n que iremos envia-ló uma nova senha"),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    onChanged: (text) {
                      email = text;
                    },
                    controller: fieldText,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        String random = "";
                        dynamic lista = [];
                        bool enviou = false;
                        lista = await teste.selectUD();
                        for (int i = 0; i < lista.length; i = i + 9) {
                          if (email == lista[i + 3]) {
                            random = geraStringAleatoria();
                            await teste.updateSenha(lista[i], random, 0);
                            await sendMail.sendEmailChangePass(
                                email: email, password: random, name: lista[1]);
                            enviou = true;
                          }
                        }
                        if (enviou) {
                          mensagem("Senha enviada",
                              "Sua nova senha foi enviada ao seu email");
                        } else {
                          mensagem("Email incorreto", "Esse email é invalido");
                        }

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

  geraStringAleatoria() {
    String stringAleatoria = '';
    String caracteres =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    for (var i = 0; i < 8; i++) {
      stringAleatoria += caracteres[Random().nextInt(caracteres.length)];
    }

    return stringAleatoria;
  }
}
