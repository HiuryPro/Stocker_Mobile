import 'package:flutter/material.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';

import '../DadosDB/crud.dart';

class AtualizaSenha extends StatefulWidget {
  const AtualizaSenha({Key? key}) : super(key: key);

  @override
  State<AtualizaSenha> createState() => _AtualizaSenhaState();
}

class _AtualizaSenhaState extends State<AtualizaSenha> {
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();
  final fieldText3 = TextEditingController();

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
    fieldText3.clear();
  }

  String senhaAntiga = '';
  String senhaNova = '';
  String senhaNovaRepetida = '';

  var teste = CRUD();

  Widget _body() {
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: ListView(
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
                    senhaAntiga = text;
                  },
                  controller: fieldText,
                  decoration: const InputDecoration(
                    labelText: 'Senha Antiga',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                    onChanged: (text) {
                      senhaNova = text;
                    },
                    controller: fieldText2,
                    decoration: const InputDecoration(
                      labelText: 'Nova Senha',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    )),
                const SizedBox(
                  height: 15,
                ),
                TextField(
                    onChanged: (text) {
                      senhaNovaRepetida = text;
                    },
                    controller: fieldText3,
                    decoration: const InputDecoration(
                      labelText: 'Repita Nova Senha',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    )),
                const SizedBox(
                  height: 15,
                ),
                ElevatedButton(
                    onPressed: () async {
                      var lista =
                          await teste.select("SELECT *  FROM usuario_login");
                      int opcao = 1;
                      for (var row in lista) {
                        if (row['senha'] == senhaAntiga) {
                          if (senhaNova == senhaNovaRepetida) {
                            await teste.update(
                                'Update usuario_login set senha = ?, nova_senha = ?  where id = ?',
                                [senhaNovaRepetida, 1, row['id']]);

                            mensagem(
                                "A senha foi atualizada com sucesso", true);
                            opcao = -1;
                            clearText();
                            break;
                          } else {
                            opcao = 0;
                            fieldText2.clear();
                            fieldText3.clear();
                          }
                        } else {
                          opcao = 1;
                          fieldText.clear();
                        }
                      }

                      if (opcao == 1) {
                        mensagem("A senha antiga está errada", false);
                      } else if (opcao == 0) {
                        mensagem(
                            "As senhas digitadas nos campos 'nova senha' \n e 'repita nova senha' estão diferentes",
                            false);
                      }
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

  Widget alert(String mensagem1, bool deixa) {
    return AlertDialog(
      title: const Text("Atualização de senha"),
      content: Text(mensagem1),
      actions: [
        TextButton(
            onPressed: () {
              if (deixa) {
                Navigator.of(context).pushNamed('/');
              } else {
                Navigator.of(context).pop();
              }
            },
            child: const Text("Ok"))
      ],
    );
  }

  mensagem(String mensagem1, bool deixa) {
    return showDialog(
      context: context,
      builder: (_) => alert(mensagem1, deixa),
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
              child: Image.asset(AppController.instance.background,
                  fit: BoxFit.cover)),
          _body()
        ]));
  }
}
