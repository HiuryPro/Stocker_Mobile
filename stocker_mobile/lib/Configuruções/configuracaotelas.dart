import 'dart:io' as plataforma;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:universal_html/html.dart';

import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
import '../Validacao_e_Gambiarra/falapratexto.dart';
import '../Validacao_e_Gambiarra/textoprafala.dart';
import '../services/supabase.databaseService.dart';

class Configuracoes extends StatefulWidget {
  const Configuracoes({super.key});

  @override
  State<Configuracoes> createState() => _ConfiguracoesState();
}

enum TtsState { playing, stopped, paused, continued }

class _ConfiguracoesState extends State<Configuracoes> {
  var drawerTela = DrawerTela();
  var navegar = Navegar();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }
      await Navegar.instance.buscaComandos();
    });
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: ListView(
          shrinkWrap: true,
          children: [
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: GestureDetector(
        onLongPress: () {
          print('segura');
        },
        onLongPressStart: (detaisl) async {
          await Fala.instance.somEntrou();
          Voz.instance.startListening();
          print('Começou a clicar');
        },
        onLongPressEnd: ((details) async {
          await Fala.instance.somSaiu();
          await Future.delayed(Duration(milliseconds: 500));
          Voz.instance.stopListening();
          await Navegar.instance.navegar(Voz.instance.lastWords, context);
        }),
        child: FloatingActionButton(
            child: Icon(Icons.phone), onPressed: () async {}),
      ),
      body: body(),
      appBar: AppBar(),
      drawer: drawerTela.drawerTela(context),
    );
  }
}
