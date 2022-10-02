import 'dart:io';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:printing/printing.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class TalkinH extends StatefulWidget {
  const TalkinH({super.key});

  @override
  State<TalkinH> createState() => _TalkinHState();
}

enum TtsState { playing, stopped, paused, continued }

class _TalkinHState extends State<TalkinH> {
  var imagem = "assets/hiury/calado.png";
  var audioPlayer = AudioPlayer();

  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  int pause = 15;

  get isPlaying => ttsState == TtsState.playing;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  bool _hasSpeech = false;
  bool _logEvents = false;
  bool falando = false;
  bool isImitando = false;

  String lastWords = '';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await initSpeechState();
    });
    initTts();
    super.initState();
  }

  initTts() {
    flutterTts = FlutterTts();

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

  Future _speak() async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(1);
    await flutterTts.setPitch(1.8);

    List<String> lista = ["Sim", "Não", "Não sei", "Pesquisa no Gugol"];

    await flutterTts.speak(lista[Random().nextInt(lista.length)]);
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _imita() async {
    await flutterTts.setVolume(1);
    await flutterTts.setSpeechRate(1);
    await flutterTts.setPitch(1.8);

    await flutterTts.speak(lastWords);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
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
      if (!mounted) return;

      setState(() {
        _hasSpeech = hasSpeech;
      });
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
        _hasSpeech = false;
      });
    }
  }

  Future<void> som(String mp3) async {
    var player = AudioCache(prefix: 'assets/sounds/');
    var url = await player.load(mp3);
    await audioPlayer.play(url.path);
  }

  void startListening() {
    _logEvent('start listening');

    speech.listen(
        onResult: resultListener,
        listenFor: Duration(seconds: 30),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
    setState(() {});
  }

  void resultListener(SpeechRecognitionResult result) {
    _logEvent(
        'Result listener final: ${result.finalResult}, words: ${result.recognizedWords}');
    setState(() {
      lastWords = result.recognizedWords;
    });
    if (!falando) {
      setState(() {
        falando = true;
      });
    }
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
      lastStatus = '$status';
    });

    if (lastStatus == 'notListening') {
      if (lastWords != '') {
        setState(() {
          imagem = "assets/hiury/hiuryfala.gif";
        });

        if (!isImitando) {
          await _speak();
        } else {
          await _imita();
        }

        setState(() {
          lastWords = '';
          imagem = "assets/hiury/calado.png";
          falando = false;
        });

        if (!isImitando) {
          List<String> cancela = ["1", "2", "3"];
          if (cancela[Random().nextInt(cancela.length)] == "3") {
            await speech.cancel();

            som("saiu.mp3");
          } else {
            await speech.cancel();

            startListening();
          }
        }
      } else {
        await speech.cancel();

        som("saiu.mp3");
      }
    }
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    print('$eventTime $eventDescription');
  }

  Widget tela() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(shrinkWrap: true, children: [
          Container(
              decoration: BoxDecoration(color: Color(0xFF6caa46)),
              width: MediaQuery.of(context).size.width,
              height: 90,
              child: Center(
                child: Image.asset(
                  "assets/hiury/talkinhiury2.png",
                ),
              )),
          GestureDetector(
            onTap: () async {
              setState(() {
                imagem = "assets/hiury/fechado.png";
              });

              await Future.delayed(Duration(milliseconds: 300));

              setState(() {
                imagem = "assets/hiury/calado.png";
              });
            },
            child: Center(child: Image.asset(imagem)),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isImitando = false;
                    });

                    som("entro.mp3");
                    startListening();
                  },
                  child: Row(
                    children: [Icon(Icons.call), Text("Conversar")],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      isImitando = true;
                    });
                    som("entro.mp3");
                    startListening();
                  },
                  child: Row(
                    children: [Icon(Icons.mic), Text("Imitar")],
                  ),
                )
              ],
            ),
          )
        ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tela(),
    );
  }
}
