import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:io' as plataforma;
import '../Metodos_das_Telas/navegar.dart';
import '../services/supabase.databaseService.dart';

class Voz extends ChangeNotifier {
  static Voz instance = Voz();
  Map<String, String> comandos = {};

  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  // ignore: unused_field
  List<LocaleName> _localeNames = [];
  static SpeechToText speech = SpeechToText();

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
    print('Inicializou');
    try {
      var hasSpeech = await speech.initialize(
        onError: errorListener,
        onStatus: (status) {
          statusListener(status);
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

  void statusListener(String status) async {
    _logEvent(
        'Received listener status: $status, listening: ${speech.isListening}');

    lastStatus = status;
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    print('$eventTime $eventDescription');
  }

  void startListening() {
    _logEvent('start listening');

    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(seconds: 30),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  void stopListening() {
    _logEvent('stop');
    speech.cancel();
  }
}
