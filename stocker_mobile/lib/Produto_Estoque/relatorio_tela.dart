import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stocker_mobile/Compra_e_Venda/tela_venda.dart';
import 'package:stocker_mobile/credentials/supabase.credentials.dart';

import '../Cria_PDF/cria_pdf.dart';
import '../Cria_PDF/uint.dart';

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Cria_PDF/cores.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
import '../Validacao_e_Gambiarra/voz.dart';

class Relatorio extends StatefulWidget {
  const Relatorio({Key? key}) : super(key: key);

  @override
  State<Relatorio> createState() => RelatorioState();
}

class RelatorioState extends State<Relatorio> {
  int count = 0;

  final deDataCompra = TextEditingController();
  final ateDataCompra = TextEditingController();
  final deDataVenda = TextEditingController();
  final ateDataVenda = TextEditingController();

  List<String> venda = ["Suco", "Cerveja", "Puta", "Caralho"];
  List<double> preco = [10, 20, 30, 40];

  String deDataC = "";
  String ateDataC = "";
  String deDataV = "";
  String ateDataV = "";
  bool carrega = false;
  bool isDone = false;

  var criaPdf = CriaPDF();
  var navegar = Navegar();
  var drawer = DrawerTela();

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

  criandoPDFCompra() async {
    var lista = await SupaBaseCredentials.supaBaseClient.rpc('relatoriocompra',
        params: {'data1': deDataC, 'data2': ateDataC}).execute();

    if (lista.data != null) {
      criaPdf.deData = deDataC;
      criaPdf.ateData = ateDataC;
      var imageToUint = Uint();
      await imageToUint.pegaImagem(1, deDataC, ateDataC);
      await criaPdf.relatoriaDadosCompra();
      await criaPdf.createPDFCompra(
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

  criandoPDFVenda() async {
    var lista = await SupaBaseCredentials.supaBaseClient.rpc('relatoriovenda',
        params: {'data1': deDataV, 'data2': ateDataV}).execute();

    if (lista.data != null) {
      criaPdf.deData = deDataV;
      criaPdf.ateData = ateDataV;
      var imageToUint = Uint();
      await imageToUint.pegaImagem(2, deDataV, ateDataV);
      await criaPdf.relatoriaDadosVenda();
      await criaPdf.createPDFVenda(
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
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: ListView(
          shrinkWrap: true,
          children: [compra(), vendatela()],
        )),
      ),
    );
  }

  Widget compra() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: Text('Gerar Relatorio de Compra',
                style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: TextField(
                    readOnly: true,
                    controller: deDataCompra,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime(3000))
                          .then((date) {
                        if (date != null) {
                          deDataCompra.text =
                              DateFormat('dd/MM/yyyy').format(date);
                          deDataC = deDataCompra.text;
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
                    controller: ateDataCompra,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime(3000))
                          .then((date) {
                        if (date != null) {
                          ateDataCompra.text =
                              DateFormat('dd/MM/yyyy').format(date);
                          ateDataC = ateDataCompra.text;
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
              onPressed: () async {
                setState(() {
                  carrega = true;
                });

                if (kIsWeb) {
                  await criandoPDFCompra();
                  criaPdf.anchor.click();
                } else {
                  if (await Permission.storage.isGranted) {
                    await criaPdf.criaDiretorio();
                    await criandoPDFCompra();
                  } else {
                    await [Permission.storage].request();

                    if (await Permission.storage.isGranted) {
                      await criaPdf.criaDiretorio();

                      await criandoPDFCompra();
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text("Need permissions"),
                      ));
                    }
                  }
                }
              },
              child: const Text("Cria PDF")),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
    );
  }

  Widget vendatela() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          const Center(
            child: Text('Gerar Relatorio de Venda',
                style: TextStyle(fontSize: 20)),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 3,
                fit: FlexFit.tight,
                child: TextField(
                    readOnly: true,
                    controller: deDataVenda,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime(3000))
                          .then((date) {
                        if (date != null) {
                          deDataVenda.text =
                              DateFormat('dd/MM/yyyy').format(date);
                          deDataV = deDataVenda.text;
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
                    controller: ateDataVenda,
                    onTap: () {
                      showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1980),
                              lastDate: DateTime(3000))
                          .then((date) {
                        if (date != null) {
                          ateDataVenda.text =
                              DateFormat('dd/MM/yyyy').format(date);
                          ateDataV = ateDataVenda.text;
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
              onPressed: () async {
                setState(() {
                  carrega = true;
                });

                if (kIsWeb) {
                  await criandoPDFVenda();
                  criaPdf.anchor.click();
                } else {
                  if (await Permission.storage.isGranted) {
                    await criaPdf.criaDiretorio();
                    await criandoPDFVenda();
                  } else {
                    await [Permission.storage].request();

                    if (await Permission.storage.isGranted) {
                      await criaPdf.criaDiretorio();

                      await criandoPDFVenda();
                    } else {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: drawer.drawerTela(context),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.phone),
            onPressed: () async {
              print(this.context);
              Voz.instance.opcao = 0;
              Voz.instance.context = this.context;
              await Voz.instance.initSpeechState();

              await Voz.instance.initTts();
              await Voz.instance.buscaComandos();

              Voz.instance.startListening();
            }),
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
