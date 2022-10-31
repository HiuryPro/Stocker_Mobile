import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:io' as plataforma;
import '../Metodos_das_Telas/navegar.dart';
import '../services/supabase.databaseService.dart';

enum TtsState { playing, stopped, paused, continued }

class Voz extends ChangeNotifier {
  static Voz instance = Voz();
  Map<String, String> comandos = {};
  var crud = DataBaseService();
  var audioPlayer = AudioPlayer();
  late Navegar navegar;

  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  int pause = 15;
  bool isEscutando = false;

  bool get isAndroid => !kIsWeb && plataforma.Platform.isAndroid;
  String lastWords = 'Home';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  // ignore: unused_field
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();
  bool isIniciado = false;
  String navegar2 = '';

  Voz() {
    navegar = Navegar();
    print('Teste');
  }

  Future<void> initSpeechState(BuildContext context) async {
    _logEvent('Initialize');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: (status) {
          statusListener(status, context);
        },
        debugLogging: true,
      );
      if (hasSpeech) {
        _localeNames = await speech.locales();

        var systemLocale = await speech.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
    } catch (e) {
      lastError = 'Speech recognition failed: ${e.toString()}';
    }
  }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');

    lastWords = result.recognizedWords;
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');

    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status, BuildContext context) async {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');

    lastStatus = status;
    print(status);

    if (status == 'notListening') {
      if (lastWords != '') {
        await _comando(context);
      } else {
        somSaiu();
        await speech.cancel();
      }
    }
  }

  Future _comando(BuildContext context) async {
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
      navegar2 = "/$acao";
      print('Chegp');
      print(navegar2);
      print(context);
      Navigator.pushNamed(context, navegar2);
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
      print("error: $msg");
      ttsState = TtsState.stopped;
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
        pauseFor: const Duration(milliseconds: 1500),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }
}
