import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/drawertela.dart';

import '../Metodos_das_Telas/navegar.dart';
import '../services/supabase.databaseService.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomePageState extends State<HomePage> {
  var crud = DataBaseService();
  var teste = const HomePage();
  var drawerTela = DrawerTela();

  Map<String, String> comandos = {};
  var navegar = Navegar();
  var audioPlayer = AudioPlayer();

  late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
  int pause = 15;
  bool isEscutando = false;

  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  String lastWords = 'Compra';
  String lastError = '';
  String lastStatus = '';
  String _currentLocaleId = '';
  // ignore: unused_field
  List<LocaleName> _localeNames = [];
  final SpeechToText speech = SpeechToText();

  void initState() {
    Future.delayed(Duration.zero, () async {
      await initSpeechState();
      await initTts();
      await buscaComandos();
    });

    super.initState();
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
        som("saiu.mp3");
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
      navegar.navegarEntreTela("/$acao", context);
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

  Future<void> som(String mp3) async {
    var player = AudioCache(prefix: 'assets/sounds/');
    var url = await player.load(mp3);
    await audioPlayer.play(url.path);
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
                  navegar.navegarEntreTela('/Cadastro', context);
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
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (isEscutando) {
            await speech.cancel();
            isEscutando = false;
          } else {
            som("entro.mp3");
            startListening();
            isEscutando = true;
          }
        },
        child: const Icon(Icons.campaign),
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
