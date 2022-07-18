import 'package:flutter/material.dart';

import 'DadosDB/crud.dart';

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

  String senhaA = '';
  String senhaN = '';
  String senhaNR = '';

  var teste = CRUD();

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
                      senhaA = text;
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
                        senhaN = text;
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
                        senhaNR = text;
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
                        List<dynamic> lista = await teste.selectUL();
                        int opcao = 1;
                        print(lista[2]);

                        for (int i = 0; i < lista.length; i = i + 5) {
                          if (lista[2] == senhaA) {
                            if (senhaN == senhaNR) {
                              await teste.updateSenha(lista[i], senhaNR, 1);
                              mensagem(
                                  "A senha foi atualizada com sucesso", true);
                              opcao = -1;
                              i = lista.length;
                              clearText();
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
                      child: const Text('Entrar')),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )));
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
        body: Stack(children: [
      SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Image.asset('images/back2.jpg', fit: BoxFit.cover)),
      _body()
    ]));
  }
}
