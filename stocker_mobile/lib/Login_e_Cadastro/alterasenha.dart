import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/services/supabase.services.dart';

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
                    print(senha.text);
                    if (senha.text == confirmaSenha.text) {
                      var resposta = await AuthenticationService.auth
                          .passwordChange(novaSenha: senha.text);
                      print(resposta.data);
                      navegar.navegarEntreTela('/', context, false);
                    } else {
                      print("Senha não são iguais");
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
}
