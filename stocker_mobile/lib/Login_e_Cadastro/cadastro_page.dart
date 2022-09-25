import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart' as provider;
import 'package:stocker_mobile/Login_e_Cadastro/insereCadastro.dart';
import 'package:supabase/supabase.dart';

import '../DadosDB/crud.dart';
import '../SendEmail/send_email.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/validacao.dart';
import '../app/providers/app.dbnotifier.dart';

class CadPage extends StatefulWidget {
  CadPage({Key? key, this.response}) : super(key: key);

  final GotrueSessionResponse? response;

  @override
  State<CadPage> createState() => _CadPageState();
}

class _CadPageState extends State<CadPage> {
  var crud = CRUD();
  var valida = Validacao();
  var enviaEmail = SendMail();

  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();
  final fieldText3 = TextEditingController();

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
    fieldText3.clear();
  }

  String nome = "", email = "", telefone = "";

  bool carrega = false;
  bool isDone = false;

  List<String> valores = [];

  var maskFormatterCnpj = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskFormatterTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  Widget _body() {
    final DataBaseNotifier authDBNotifier =
        provider.Provider.of<DataBaseNotifier>(context, listen: false);

    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(AppController.instance.logo)),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: fieldText,
                    onChanged: (text) {
                      setState(() {
                        nome = text;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Nome da Empresa',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: fieldText2,
                      inputFormatters: [maskFormatterTelefone],
                      onChanged: (text) {
                        setState(() {
                          telefone = maskFormatterTelefone.getUnmaskedText();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Telefone',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        Map<String, dynamic> map = {
                          "id": widget.response!.user!.id,
                          "nomeAdministrador": fieldText.text,
                          "email": widget.response!.user!.email,
                          "telefone": maskFormatterTelefone.getUnmaskedText()
                        };
                        await authDBNotifier.insert(
                            tabela: "Usuario", map: map);
                      },
                      child: Text("Cadastra dados do usuario"))
                ],
              ),
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
        body: Stack(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.asset(AppController.instance.background,
                    fit: BoxFit.cover)),
            _body(),
            if (carrega) telaCarrega()[0],
            if (carrega) telaCarrega()[1]
          ],
        ));
  }

  List<Widget> telaCarrega() {
    return [
      Container(
        color: Colors.white.withOpacity(0.7),
      ),
      const Center(child: (CircularProgressIndicator(color: Color(0xFF0080d9))))
    ];
  }

  Widget alert(String mensagem) {
    return AlertDialog(
      title: const Text("Cadastro"),
      content: Text(mensagem),
      actions: [
        TextButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: const Text("Ok"))
      ],
    );
  }

  mensagem(String mensagem) {
    return showDialog(
      context: context,
      builder: (_) => alert(mensagem),
      barrierDismissible: true,
    );
  }
}
