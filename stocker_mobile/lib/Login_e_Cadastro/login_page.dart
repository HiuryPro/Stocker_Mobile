import 'package:flutter/material.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/on_hover.dart';
import '../services/supabase.services.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();
  final _textFieldController = TextEditingController();

  var theme = AppController();
  var navegar = Navegar();

  String usuario = '';
  String senha = '';

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
  }

  Widget alert(var mensagem) {
    return AlertDialog(
      title: const Text("Atualização de senha"),
      content: Text(mensagem),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"))
      ],
    );
  }

  mensagem(var mensagem) {
    return showDialog(
      context: context,
      builder: (_) => alert(mensagem),
      barrierDismissible: true,
    );
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
                      var resposta = await AuthenticationService.auth.signIn(
                          email: fieldText.text, senha: fieldText2.text);
                      print(resposta.data);
                      if (resposta.error == null) {
                        print(resposta.user!.id);
                        setState(() {
                          AppController.instance.response = resposta;
                        });

                        // ignore: use_build_context_synchronously
                        navegar.navegarEntreTela('/Home', context, false);
                      } else {
                        print(resposta.error!.message);
                      }
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
                OnHover(builder: (isHovered) {
                  final color = isHovered
                      ? AppController.instance.theme2
                      : AppController.instance.theme1;
                  Colors.black;
                  return GestureDetector(
                    onTap: () {
                      navegar.navegarEntreTela('/novasenhapage', context, true);
                    },
                    child: Center(
                      child: Text("Esqueci minha Senha ?",
                          style: TextStyle(color: color, fontSize: 16)),
                    ),
                  );
                }),
                const SizedBox(
                  height: 20,
                ),
                OnHover(builder: (isHovered) {
                  final color = isHovered
                      ? AppController.instance.theme2
                      : AppController.instance.theme1;
                  return GestureDetector(
                    onTap: () {
                      navegar.navegarEntreTela(
                          '/CadastroUsuario', context, true);
                    },
                    child: Center(
                      child: Text("Ainda não é cadastrado ?",
                          style: TextStyle(color: color, fontSize: 16)),
                    ),
                  );
                }),
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: null,
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
}
