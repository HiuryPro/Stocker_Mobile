import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stocker_mobile/Login_e_Cadastro/cadastro_page.dart';
import 'package:stocker_mobile/app/providers/app.authentication.dart';
import 'package:stocker_mobile/app/providers/app.dbnotifier.dart';
import 'package:stocker_mobile/credentials/supabase.credentials.dart';

class Teste extends StatefulWidget {
  const Teste({Key? key}) : super(key: key);

  @override
  State<Teste> createState() => _TesteState();
}

// ; : "" []
class _TesteState extends State<Teste> {
  String nome = "Hiury";
  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final DataBaseNotifier authDBNotifier =
        Provider.of<DataBaseNotifier>(context, listen: false);
    final AuthenticationNotifier authNotifier =
        Provider.of<AuthenticationNotifier>(context, listen: false);

    return Scaffold(
        body: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: ListView(shrinkWrap: true, children: [
                  TextField(
                      controller: fieldText,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), label: Text("Eamil"))),
                  const SizedBox(height: 15),
                  TextField(
                      controller: fieldText2,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(), label: Text("Senha"))),
                  const SizedBox(height: 15),
                  ElevatedButton(
                      onPressed: () async {
                        var resposta = await authNotifier.signIn(
                            email: fieldText.text, senha: fieldText2.text);

                        if (resposta.error == null) {
                          print(resposta.user!.id);
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      CadPage(response: resposta)),
                              (Route<dynamic> route) => false);
                        } else {
                          print(resposta.error!.message);
                        }
                      },
                      child: const Text("Login"))
                ])))));
  }
}
