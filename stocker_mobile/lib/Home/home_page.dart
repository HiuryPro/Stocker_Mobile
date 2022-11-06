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

import 'package:universal_html/html.dart';

import '../Metodos_das_Telas/navegar.dart';

import '../Validacao_e_Gambiarra/voz.dart';
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
        await window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }
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
          SizedBox(height: 15),
          Center(
            child: ElevatedButton(
                onPressed: () async {
                  var teste = await AuthenticationService.auth
                      .passwordChange(novaSenha: '1234567');
                  print(teste.data);
                },
                child: Text("Mudar Senha")),
          )
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
                  navegar.navegarEntreTela('/Cadastro', context, true);
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

            //  navegar.navegarEntreTela(voz.navegar, context);
          }),
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
