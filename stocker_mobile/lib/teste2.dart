import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stocker_mobile/Metodos_das_Telas/navegar.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/textoprafala.dart';
import 'package:universal_html/html.dart' as html;

import 'Validacao_e_Gambiarra/falapratexto.dart';

class Teste extends StatefulWidget {
  const Teste({super.key});

  @override
  State<Teste> createState() => _TesteState();
}

class _TesteState extends State<Teste> {
  Color iconColor = Colors.blue;
  String falou = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await html.window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }
      await Navegar.instance.buscaComandos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: GestureDetector(
      onLongPress: () {
        print('segura');
      },
      onLongPressStart: (detaisl) async {
        await Fala.instance.somEntrou();
        Voz.instance.startListening();

        print(detaisl);
        setState(() {
          iconColor = Colors.green;
        });
        print('Começou a clicar');
      },
      onLongPressEnd: ((details) async {
        print(details);
        setState(() {
          iconColor = Colors.blue;
        });

        await Future.delayed(Duration(milliseconds: 500));
        Voz.instance.stopListening();
        await Navegar.instance.navegar(Voz.instance.lastWords, context);
      }),
      child: Icon(Icons.mic, color: iconColor),
    ));
  }
}
