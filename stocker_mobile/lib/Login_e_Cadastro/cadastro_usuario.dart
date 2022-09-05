import 'package:flutter/material.dart';

import '../Metodos_das_Telas/login_metodos.dart';
import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/on_hover.dart';

class CadUser extends StatefulWidget {
  const CadUser({Key? key}) : super(key: key);

  @override
  State<CadUser> createState() => _CadUserState();
}

class _CadUserState extends State<CadUser> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  var theme = AppController();
  var login = Login();
  var navegar = Navegar();

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
                      if (await login.mudaSenha(usuario, senha)) {
                        navegar.navegarEntreTela('/atualizasenha', context);
                      } else if (await login.autorizaLogin(usuario, senha)) {
                        if (await login.novoLogin(usuario, senha)) {
                          navegar.navegarEntreTela('/novoCadUser', context);
                          AppController.instance
                              .mudaLogin(login.getAlteraLoginID());
                        } else {
                          navegar.navegarEntreTela('/homepage', context);
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
                OnHover(builder: (isHovered) {
                  final color = isHovered
                      ? AppController.instance.theme2
                      : AppController.instance.theme1;
                  Colors.black;
                  return GestureDetector(
                    onTap: () {
                      navegar.navegarEntreTela('/novasenhapage', context);
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
                      navegar.navegarEntreTela('/cadpage', context);
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
