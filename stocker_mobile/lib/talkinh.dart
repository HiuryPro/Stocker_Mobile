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

import 'Metodos_das_Telas/navegar.dart';
import 'services/supabase.databaseService.dart';

class TalkinH extends StatefulWidget {
  const TalkinH({super.key});

  @override
  State<TalkinH> createState() => _TalkinHState();
}

enum TtsState { playing, stopped, paused, continued }

class _TalkinHState extends State<TalkinH> {
  var crud = DataBaseService();

  Map<String, String> comandos = {};

  var imagem = "assets/hiury/calado.png";
  var audioPlayer = AudioPlayer();
  var navegar = Navegar();

  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  int pause = 15;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;

  bool isConversa = false;
  bool isImitando = false;
  bool isComando = false;
  bool isEscutando = false;

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
      await initTts();
      await buscaComandos();
    });

    super.initState();
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

  Future _speak() async {
    List<String> lista = ["Sim", "Não", "Não sei", "Pesquisa no Gugol"];

    await flutterTts.speak(lista[Random().nextInt(lista.length)]);
  }

  Future _imita() async {
    await flutterTts.speak(lastWords);
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
    } else {
      await flutterTts.speak("Esse Comando não existe");
    }
  }

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
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
    } catch (e) {
      setState(() {
        lastError = 'Speech recognition failed: ${e.toString()}';
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

  Future<void> opcoesFala() async {
    if (isConversa) {
      await _speak();
    }
    if (isImitando) {
      await _imita();
      await Future.delayed(Duration(milliseconds: 250));
      som('saiu.mp3');
      isEscutando = false;
    }
    if (isComando) {
      await _comando();
      isEscutando = false;
    }
  }

  Future<void> aposConversa() async {
    if (isConversa) {
      List<int> cancela = [1, 2, 3, 4];
      if (cancela[Random().nextInt(cancela.length)] == 3) {
        await speech.cancel();
        isEscutando = false;
        som("saiu.mp3");
      } else {
        await speech.cancel();
        Future.delayed(Duration(milliseconds: 500));
        startListening();
      }
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
      lastStatus = '$status';
    });

    if (lastStatus == 'notListening') {
      if (lastWords != '') {
        setState(() {
          imagem = "assets/hiury/hiuryfala.gif";
        });

        await opcoesFala();

        setState(() {
          lastWords = '';
          imagem = "assets/hiury/calado.png";
        });

        aposConversa();
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
                    if (!isEscutando) {
                      setState(() {
                        isConversa = true;
                        isComando = false;
                        isImitando = false;
                        isEscutando = true;
                      });

                      som("entro.mp3");
                      startListening();
                    } else {
                      await speech.cancel();
                      som('saiu.mp3');
                      setState(() {
                        isEscutando = false;
                      });
                    }
                  },
                  child: Row(
                    children: [Icon(Icons.call), Text("Conversar")],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (!isEscutando) {
                      setState(() {
                        isConversa = false;
                        isImitando = true;
                        isComando = false;
                        isEscutando = true;
                      });
                      som("entro.mp3");
                      startListening();
                    } else {
                      await speech.cancel();
                      som('saiu.mp3');
                      setState(() {
                        isEscutando = false;
                      });
                    }
                  },
                  child: Row(
                    children: [Icon(Icons.mic), Text("Imitar")],
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (!isEscutando) {
                      setState(() {
                        isConversa = false;
                        isImitando = false;
                        isComando = true;
                        isEscutando = true;
                      });
                      som("entro.mp3");
                      startListening();
                    } else {
                      await speech.cancel();
                      som('saiu.mp3');
                      setState(() {
                        isEscutando = false;
                      });
                    }
                  },
                  child: Row(
                    children: [Icon(Icons.mic), Text("Comandos")],
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
