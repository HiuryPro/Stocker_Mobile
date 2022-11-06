import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/credentials/supabase.credentials.dart';
import 'package:stocker_mobile/services/supabase.services.dart';
import 'package:supabase/supabase.dart';
import 'package:universal_html/html.dart';

import '../Metodos_das_Telas/navegar.dart';

class AlteraSenha extends StatefulWidget {
  const AlteraSenha({super.key});

  @override
  State<AlteraSenha> createState() => _AlteraSenhaState();
}

class _AlteraSenhaState extends State<AlteraSenha> {
  TextEditingController senha = TextEditingController();
  TextEditingController confirmaSenha = TextEditingController();
  var navegar = Navegar();
  var hash;
  var teste;
  var hashArr;
  var acesstoken;
  var value;

  @override
  void initState() {
    super.initState();
    setState(() {
      hash = window.location.hash;
      hashArr = hash.substring(1).split("&").map((param) => param.split("="));
    });

    if (hashArr.length >= 2) {
      List<String> lista = [];
      for (var teste in hashArr) {
        lista = teste;
      }

      if (lista[1] == "signup") {
        Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
      }
    }
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: SizedBox(
                    width: 400,
                    child: Image.asset(AppController.instance.logo)),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                obscureText: true,
                controller: senha,
                decoration: InputDecoration(label: Text("Senha")),
              ),
              TextField(
                obscureText: true,
                controller: confirmaSenha,
                decoration: InputDecoration(label: Text("Confirmar a senha")),
              ),
              ElevatedButton(
                  onPressed: () async {
                    List<String> lista = [];
                    for (var teste in hashArr) {
                      lista = teste;
                      break;
                    }

                    if (senha.text == confirmaSenha.text) {
                      GotrueUserResponse resposta = await SupaBaseCredentials
                          .supaBaseClient.auth.api
                          .updateUser(
                              lista[1], UserAttributes(password: senha.text));
                      await mensagem(resposta.user!.id);
                      if (resposta.user != null) {
                        Navigator.pushNamed(context, "/login");
                      } else {
                        await mensagem(resposta.error);
                      }
                    }
                  },
                  child: Text("Salavr Nova Senha"))
            ],
          ))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Widget alert(dynamic mensagem1) {
    return AlertDialog(
      title: Text("teste"),
      content: Text(mensagem1),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text("Ok"))
      ],
    );
  }

  Future<dynamic> mensagem(dynamic mensagem1) async {
    return await showDialog(
      context: context,
      builder: (_) => alert(mensagem1),
      barrierDismissible: true,
    );
  }
}
