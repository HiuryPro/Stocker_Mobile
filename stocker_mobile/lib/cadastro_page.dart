import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import 'db.dart';

class CadPage extends StatefulWidget {
  const CadPage({Key? key}) : super(key: key);

  @override
  State<CadPage> createState() => _CadPageState();
}

class _CadPageState extends State<CadPage> {
  var teste = UserService();
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
                    inputFormatters: [maskFormatterCnpj],
                    onChanged: (text) {
                      setState(() {
                        cnpj = maskFormatterCnpj.getUnmaskedText();
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Cnpj',
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                    )),
                const SizedBox(
                  height: 15,
                ),
                TextField(
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
                        valores.add(ganho);
                        valores.add(telefone);

                        await teste.cadUsuario(valores);
                        valores.clear();
                      },
                      child: const Text('Cadastrar')),
                )
              ],
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
}
