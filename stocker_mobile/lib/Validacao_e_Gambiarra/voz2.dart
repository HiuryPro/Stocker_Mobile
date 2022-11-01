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

enum TtsState2 { playing, stopped, paused, continued }

class Voz2 extends ChangeNotifier {
  static Voz2 instance = Voz2();
  var crud = DataBaseService();
  final audioPlayer = AudioPlayer();
  late Navegar navegar;

  static late FlutterTts flutterTts;
  TtsState2 ttsState = TtsState2.stopped;
  int pause = 15;
  bool isEscutando = false;

  bool get isAndroid => !kIsWeb && plataforma.Platform.isAndroid;
  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  // ignore: unused_field
  List<LocaleName> _localeNames = [];
  static SpeechToText speech = SpeechToText();
  bool isIniciado = false;
  String navegar2 = '';
  Map<String, String> palavras = {};
  List<String> palavrasChaves = ['produto', 'quantidade', 'fornecedor'];

  Voz() {
    navegar = Navegar();
    print('Teste');
  }

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
    } catch (e) {
      lastError = 'Speech recognition failed: ${e.toString()}';
    }
  }

  Future<void> mensagem(String mensagem) async {
    await flutterTts.speak(mensagem);
  }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');

    lastWords = result.recognizedWords;
    print(lastWords);
  }

  void errorListener(SpeechRecognitionError error) {
    _logEvent(
        'Received error status: $error, listening: ${speech.isListening}');

    lastError = '${error.errorMsg} - ${error.permanent}';
  }

  void statusListener(String status) async {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');

    lastStatus = status;
    print(status);
    print(lastWords);
    if (status == 'notListening') {
      print(lastWords);
      if (lastWords != '') {
        await _comando();
      } else {
        somSaiu();
        await speech.cancel();
      }
    }
  }

  Future _comando() async {
    String? acao;
    bool isPalavraChave = false;
    for (int i = 0; i < palavrasChaves.length; i++) {
      print(lastWords
          .substring(0, lastWords.indexOf(RegExp(r"[ ]")))
          .toLowerCase());
      if (lastWords
              .substring(0, lastWords.indexOf(RegExp(r"[ ]")))
              .toLowerCase() ==
          palavrasChaves[i].toLowerCase()) {
        isPalavraChave = true;
        acao = palavrasChaves[i];
        break;
      }
    }

    if (isPalavraChave) {
      await flutterTts.speak("$acao");

      palavras.addAll({
        lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]"))): lastWords
            .substring(lastWords.indexOf(RegExp(r"[ ]")) + 1, lastWords.length)
      });
    } else {
      await flutterTts.speak("Esse Comando não existe");
    }

    notifyListeners();
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    print('$eventTime $eventDescription');
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
      ttsState = TtsState2.stopped;
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
        pauseFor: const Duration(milliseconds: 2000),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }
}
