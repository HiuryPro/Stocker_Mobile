import 'dart:io' as plataforma;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/drawertela.dart';
import 'package:stocker_mobile/services/supabase.services.dart';

import 'package:universal_html/html.dart' as html;

import '../Metodos_das_Telas/navegar.dart';

import '../Validacao_e_Gambiarra/falapratexto.dart';
import '../Validacao_e_Gambiarra/textoprafala.dart';
import '../services/supabase.databaseService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomePageState extends State<HomePage> {
  var drawerTela = DrawerTela();
  var auth = AuthenticationService();
  var navegar = Navegar();
  late Voz voz;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    voz = Voz();
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

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        shrinkWrap: true,
        children: [
          card(),
        ],
      ),
    );
  }

  Widget card() {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
              height: 70,
              width: 200,
              child: Image.asset(AppController.instance.logo)),
          const Text(
            'Bem Vindo ao Stocker',
            style: TextStyle(fontSize: 20),
          ),
          const Text(
            'Começe cadastrando os dados de sua empresa',
            style: TextStyle(fontSize: 20),
          ),
          Center(
            child: SizedBox(
              height: 40,
              child: ElevatedButton(
                child: const Text(
                  "Cadastrar",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed('/Cadastro');
                },
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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
          await Future.delayed(const Duration(milliseconds: 500));
          Voz.instance.stopListening();
          var tela = Voz.instance.lastWords;
          Voz.instance.lastWords = '';
          // ignore: use_build_context_synchronously
          await Navegar.instance.navegar(tela, context);
        }),
        child: FloatingActionButton(
            child: Icon(Icons.phone), onPressed: () async {}),
      ),
      appBar: AppBar(
        foregroundColor: AppController.instance.theme1,
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
      ),
      drawer: drawerTela.drawerTela(context),
      body: Stack(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              AppController.instance.background,
              fit: BoxFit.cover,
            ),
          ),
          body()
        ],
      ),
    );
  }
}
