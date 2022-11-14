import 'dart:math';

import 'package:flutter/material.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';
import 'package:stocker_mobile/services/supabase.services.dart';
import 'package:universal_html/html.dart';
import '../DadosDB/crud.dart';
import '../SendEmail/send_email.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';

class NovaSenhaPage extends StatefulWidget {
  const NovaSenhaPage({Key? key}) : super(key: key);

  @override
  State<NovaSenhaPage> createState() => _NovaSenhaPageState();
}

class _NovaSenhaPageState extends State<NovaSenhaPage> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();
  var auth = AuthenticationService();
  var url = window.location.href;

  var crud = DataBaseService();
  var sendMail = SendMail();

  String email = '';

  void clearText() {
    fieldText.clear();
  }

  Widget _body() {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: SizedBox(
                      width: 400,
                      child: Image.asset(AppController.instance.logo)),
                ),
                const SizedBox(
                  height: 15,
                ),
                const Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 20),
                      "Informe o email que está vinculado a seu cadastrado \n que iremos envia-ló uma nova senha"),
                ),
                Text(url.substring(0, url.indexOf(RegExp(r'[#]')) + 1)),
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
                      var resposta =
                          await AuthenticationService.auth.passwordReset(
                        email: fieldText.text,
                      );
                      print(resposta.data);

                      clearText();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppController.instance.theme2,
                      textStyle: const TextStyle(fontSize: 24),
                      minimumSize: const Size.fromHeight(72),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Entrar')),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushNamedAndRemoveUntil(
                    '/', (Route<dynamic> route) => false);
              },
            ),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            actions: [
              Row(
                children: [
                  const Icon(Icons.arrow_left_sharp),
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
        body: Stack(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Image.asset(AppController.instance.background,
                  fit: BoxFit.cover)),
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
