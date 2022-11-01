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
  var crud = DataBaseService();

  Map<String, String> comandos = {};
  var audioPlayer = AudioPlayer();

  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  int pause = 15;
  bool isEscutando = false;

  bool get isAndroid => !kIsWeb && plataforma.Platform.isAndroid;
  String lastWords = 'Compra';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  // ignore: unused_field
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  bool isIniciado = false;

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: statusListener,
        debugLogging: true,
      );
      if (hasSpeech) {
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
      if (!mounted) return;
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
      });
    }
  }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');

    setState(() {
      lastWords = result.recognizedWords;
    });
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');

    setState(() {
      lastError = '${error.errorMsg} - ${error.permanent}';
    });
  }

  void statusListener(String status) async {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');

    setState(() {
      lastStatus = status;
    });

    if (lastStatus == 'notListening') {
      if (lastWords != '') {
        await _comando();
        isEscutando = false;

        setState(() {
          lastWords = '';
        });
      } else {
        somSaiu();
        await speech.cancel();
      }
    }
  }

  Future _comando() async {
    List<String> comandosDados = comandos.keys.toList();
    String? acao;
    bool isComandoExistente = false;
    for (int i = 0; i < comandosDados.length; i++) {
      if (lastWords.toLowerCase() == comandosDados[i].toLowerCase()) {
        isComandoExistente = true;
        acao = comandos[comandosDados[i]];
        break;
      }
    }

    if (isComandoExistente) {
      await flutterTts.speak("Tela ${acao!}");
      await Future.delayed(const Duration(seconds: 1));
      // ignore: use_build_context_synchronously
      navegar.navegarEntreTela("/$acao", context, true);
    } else {
      await flutterTts.speak("Esse Comando não existe");
    }
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    print('$eventTime $eventDescription');
  }

  Future<void> buscaComandos() async {
    List<dynamic> teste = await crud.selectComando(
        tabela: "Comando", select: "comando, acao", id: 1);
    for (var row in teste) {
      comandos
          .addEntries(<String, String>{row['comando']: row['acao']}.entries);
    }

    print(comandos.keys.toList());
    print(comandos);
  }

  initTts() async {
    flutterTts = FlutterTts();
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(1);
    await flutterTts.setPitch(1.8);

    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      print(engine);
    }
  }

  Future _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      print(voice);
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future<void> somEntrou() async {
    var player = AudioCache(prefix: 'assets/sounds/');
    var url = await player.load('entro.mp3');
    await audioPlayer.play(url.path);
  }

  Future<void> somSaiu() async {
    var player = AudioCache(prefix: 'assets/sounds/');
    var url = await player.load('saiu.mp3');
    await audioPlayer.play(url.path);
  }

  void startListening() {
    _logEvent('start listening');

    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.delayed(Duration.zero, () async {
      await initTts();
      await initSpeechState();
      await buscaComandos();
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
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.phone),
          onPressed: () async {
            if (isEscutando) {
              await speech.cancel();
              await somSaiu();
            } else {
              await somEntrou();
              startListening();
            }
          }),
      body: body(),
      appBar: AppBar(),
      drawer: drawerTela.drawerTela(context),
    );
  }
}
