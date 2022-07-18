import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'DadosDB/crud.dart';
import 'DadosDB/validacao.dart';
import 'sendEmail/send_email.dart';

class CadPage extends StatefulWidget {
  const CadPage({Key? key}) : super(key: key);

  @override
  State<CadPage> createState() => _CadPageState();
}

class _CadPageState extends State<CadPage> {
  var teste = CRUD();
  var valida = Validacao();
  var enviaEmail = SendMail();

  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();
  final fieldText3 = TextEditingController();
  final fieldText4 = TextEditingController();
  final fieldText5 = TextEditingController();
  final fieldText6 = TextEditingController();
  final fieldText7 = TextEditingController();
  final fieldText8 = TextEditingController();

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
    fieldText3.clear();
    fieldText4.clear();
    fieldText5.clear();
    fieldText6.clear();
    fieldText7.clear();
    fieldText8.clear();
  }

  String nomeE = "",
      cnpj = "",
      email = "",
      endereco = "",
      cidade = "",
      estado = "",
      telefone = "",
      ganho = "";

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
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Theme(
              data: ThemeData(
                primaryColor: Colors.black,
                primaryColorDark: Colors.black,
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset('images/Stocker_blue_transp.png')),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                    controller: fieldText,
                    onChanged: (text) {
                      setState(() {
                        nomeE = text;
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
                      inputFormatters: [maskFormatterCnpj],
                      onChanged: (text) {
                        setState(() {
                          cnpj = maskFormatterCnpj.getUnmaskedText();
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'CNPJ',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: fieldText3,
                      onChanged: (text) {
                        setState(() {
                          email = text;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: fieldText4,
                      onChanged: (text) {
                        setState(() {
                          endereco = text;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Endereço',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: fieldText5,
                      onChanged: (text) {
                        setState(() {
                          cidade = text;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Cidade',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: fieldText6,
                      onChanged: (text) {
                        setState(() {
                          estado = text;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Estado',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  TextField(
                      controller: fieldText7,
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
                  TextField(
                      controller: fieldText8,
                      onChanged: (text) {
                        setState(() {
                          ganho = text;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Ganho Mensal',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                  const SizedBox(
                    height: 15,
                  ),
                  Center(
                    child: ElevatedButton(
                        onPressed: () async {
                          valores.add(nomeE);
                          valores.add(cnpj);
                          valores.add(email);
                          valores.add(endereco);
                          valores.add(cidade);
                          valores.add(estado);
                          valores.add(telefone);
                          valores.add(ganho);

                          if (await valida.isVazio(valores)) {
                            if (valida.validacnpj(cnpj)) {
                              if (await valida.validaCad(
                                  nomeE, cnpj, email, telefone, endereco)) {
                                mensagem("Cadastro feito com sucesso");
                                valida.abrevia(nomeE);
                                await teste.insertUD(valores);
                                await teste.inserUL(
                                    valida.abrevia(nomeE), cnpj);
                                await enviaEmail.sendEmailWelcome(
                                    abrevia: valida.abrevia(valores[0]),
                                    cnpj: valores[1],
                                    name: valores[0],
                                    email: valores[2]);

                                clearText();
                              } else {
                                mensagem(valida.getMensagem());
                              }
                            } else {
                              mensagem("CNPJ inválido");
                            }
                          } else {
                            mensagem(valida.getMensagem());
                          }
                          valores.clear();
                        },
                        child: const Text('Cadastrar')),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('images/back2.jpg', fit: BoxFit.cover)),
        _body()
      ],
    ));
  }

  Widget alert(String mensagem) {
    return AlertDialog(
      title: const Text("Cadastro"),
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

  mensagem(String mensagem) {
    return showDialog(
      context: context,
      builder: (_) => alert(mensagem),
      barrierDismissible: true,
    );
  }
}
