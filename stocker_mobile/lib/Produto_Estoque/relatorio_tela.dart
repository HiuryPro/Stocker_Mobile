import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stocker_mobile/credentials/supabase.credentials.dart';

import '../Cria_PDF/cria_pdf.dart';
import '../Cria_PDF/uint.dart';

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Cria_PDF/cores.dart';

class Relatorio extends StatefulWidget {
  const Relatorio({Key? key}) : super(key: key);

  @override
  State<Relatorio> createState() => RelatorioState();
}

class RelatorioState extends State<Relatorio> {
  int count = 0;

  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  List<String> venda = ["Suco", "Cerveja", "Puta", "Caralho"];
  List<double> preco = [10, 20, 30, 40];

  String deData = "";
  String ateData = "";
  bool carrega = false;
  bool isDone = false;

  var criaPdf = CriaPDF();
  var navegar = Navegar();

  Cores cor = Cores();

  // ignore: prefer_typing_uninitialized_variables
  var anchor;

  var dateMask = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateMask2 = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  criandoPDF() async {
    var lista = await SupaBaseCredentials.supaBaseClient.rpc('relatoriocompra',
        params: {'data1': deData, 'data2': ateData}).execute();

    if (lista.data != null) {
      criaPdf.deData = deData;
      criaPdf.ateData = ateData;
      var imageToUint = Uint();
      await imageToUint.pegaImagem();
      await criaPdf.relatoriaDados();
      await criaPdf.createPDF(
          imageLogo: imageToUint.image,
          bytesImage: imageToUint.bytes,
          bytesImage2: imageToUint.bytes2);
      setState(() {
        carrega = false;
      });
      mensagem(
          "Relatório gerado com sucesso! Arquivo baixado na pasta dowloadas");
    } else {
      setState(() {
        carrega = false;
      });
      mensagem("Não há registros neste período");
    }
  }

  Widget body() {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: TextField(
                      readOnly: true,
                      controller: fieldText,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1980),
                                lastDate: DateTime(3000))
                            .then((date) {
                          if (date != null) {
                            fieldText.text =
                                DateFormat('dd/MM/yyyy').format(date);
                            deData = fieldText.text;
                          }
                        });
                      },

                      //inputFormatters: [dateMask],
                      decoration: const InputDecoration(
                        labelText: 'Dé',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                ),
                Flexible(
                  flex: 3,
                  fit: FlexFit.tight,
                  child: TextField(
                      readOnly: true,
                      controller: fieldText2,
                      onTap: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1980),
                                lastDate: DateTime(3000))
                            .then((date) {
                          if (date != null) {
                            fieldText2.text =
                                DateFormat('dd/MM/yyyy').format(date);
                            ateData = fieldText2.text;
                          }
                        });
                      },
                      inputFormatters: [dateMask2],
                      decoration: const InputDecoration(
                        labelText: 'Até',
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red)),
                      )),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed("/");
                },
                child: const Text("Voltar")),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  setState(() {
                    carrega = true;
                  });

                  if (kIsWeb) {
                    await criandoPDF();
                    criaPdf.anchor.click();
                  } else {
                    if (await Permission.storage.isGranted) {
                      await criaPdf.criaDiretorio();
                      await criandoPDF();
                    } else {
                      await [Permission.storage].request();

                      if (await Permission.storage.isGranted) {
                        await criaPdf.criaDiretorio();

                        await criandoPDF();
                      } else {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Need permissions"),
                        ));
                      }
                    }
                  }
                },
                child: const Text("Cria PDF")),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () {
                  navegar.navegarEntreTela("/telaCompra", context, true);
                },
                child: const Text("Tela de Compra")),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
              color: AppController.instance.isDarkTheme
                  ? Colors.white
                  : Colors.black,
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
            body(),
            if (carrega) telaCarrega()[0],
            if (carrega) telaCarrega()[1],
          ],
        ));
  }

  List<Widget> telaCarrega() {
    return [
      Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.white.withOpacity(0.7),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                  child: CircularProgressIndicator(color: Color(0xFF0080d9))),
              SizedBox(height: 10),
              Center(
                  child: Text(
                      textAlign: TextAlign.center,
                      "Espere! Seu relatório está sendo gerado!",
                      style: TextStyle(fontSize: 25, color: Colors.black))),
            ]),
      ),
    ];
  }

  Widget alert(String mensagem) {
    return AlertDialog(
      title: const Text("Relatório"),
      content: Text(
        mensagem,
        textAlign: TextAlign.center,
      ),
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
