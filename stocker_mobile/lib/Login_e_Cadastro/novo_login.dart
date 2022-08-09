import 'package:flutter/material.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';

import '../DadosDB/crud.dart';
import '../Validacao_e_Gambiarra/gambiarra.dart';

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
          child: Center(
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: SizedBox(
                      width: 400,
                      child: Image.asset(AppController.instance.img2)),
                ),
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
                    style: ElevatedButton.styleFrom(
                      primary: AppController.instance.theme2,
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
        body: Stack(children: [
          SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child:
                  Image.asset(AppController.instance.img, fit: BoxFit.cover)),
          _body()
        ]));
  }
}
