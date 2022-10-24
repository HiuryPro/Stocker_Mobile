import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Metodos_das_Telas/login_metodos.dart';
import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/on_hover.dart';
import '../app/providers/app.authentication.dart';
import '../services/supabase.services.dart';

class CadUsuario extends StatefulWidget {
  const CadUsuario({Key? key}) : super(key: key);

  @override
  State<CadUsuario> createState() => _CadUsuarioState();
}

class _CadUsuarioState extends State<CadUsuario> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  var theme = AppController();
  var login = Login();
  var navegar = Navegar();
  var cadastrar = AuthenticationService();

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
                TextField(
                  onChanged: (text) {
                    usuario = text;
                  },
                  controller: fieldText,
                  decoration: const InputDecoration(
                    labelText: 'Email Usuário',
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
                      var response = await cadastrar.signUp(
                          context: context,
                          email: fieldText.text,
                          senha: fieldText2.text);

                      if (response.error == null) {
                        mostraAlerta(
                            'Sucesso', 'Cadastro feito com sucesso!!', true);
                      } else {
                        mostraAlerta(
                            'Erro', 'Erro ao Cadastrar Usuário', false);
                      }
                      clearText();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppController.instance.theme2,
                      textStyle: const TextStyle(fontSize: 24),
                      minimumSize: const Size.fromHeight(72),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text('Cadastrar')),
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
              child: Image.asset(AppController.instance.background,
                  fit: BoxFit.cover)),
          _body()
        ]));
  }

  mostraAlerta(String msg1, String msg2, bool sucesso) {
    return showDialog(
        context: context,
        builder: (_) => alert(msg1, msg2, sucesso),
        barrierDismissible: false);
  }

  Widget alert(String msg1, String msg2, bool sucesso) {
    return AlertDialog(
      title: Text(msg1),
      content: Text(msg2),
      actions: [
        TextButton(
            onPressed: () {
              if (sucesso) {
                navegar.navegarEntreTela('/', context);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Ok"))
      ],
    );
  }
}