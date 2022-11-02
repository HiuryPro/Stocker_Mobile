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
  final audioPlayer = AudioPlayer();
  late Navegar navegar;

  static late FlutterTts flutterTts;
  TtsState ttsState = TtsState.stopped;
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
  bool opcao = true;
  late BuildContext context;
  String produtoSelecionado = "";

  Voz() {
    navegar = Navegar();
    print('Teste');
  }

  Future<void> initSpeechState() async {
    _logEvent('Initialize');
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
    print(status);
    print(opcao);

    if (status == 'notListening') {
      print(lastWords);
      if (lastWords != '') {
        if (opcao) {
          await _comando();
        } else {
          await _comando2();
        }
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

    lastWords = '';
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

  Future _comando2() async {
    String? acao;
    bool isPalavraChave = false;
    List<String> produtos = [];
    List<String> fornecedores = [];

    var lista = await crud.selectInner(
        tabela: "FornecedorProduto",
        select:
            'Preco, Frete, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(Pessoa!inner(IdPessoa, Nome))',
        where: {});
    print(lista);

    if (lista != null) {
      for (var row in lista) {
        produtos.add(
            "${row["Produto"]["IdProduto"]} ${row["Produto"]["NomeProduto"]}");
      }
    }

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

      if (lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]"))) ==
          'produto') {
        bool isProdutoExiste = false;
        for (int i = 0; i < produtos.length; i++) {
          if (lastWords
                  .substring(
                      lastWords.indexOf(RegExp(r"[ ]")) + 1, lastWords.length)
                  .toLowerCase() ==
              produtos[i]
                  .substring(produtos[i].indexOf(RegExp(r"[ ]")) + 1,
                      produtos[i].length)
                  .toLowerCase()) {
            isProdutoExiste = true;
            produtoSelecionado = produtos[i];
            break;
          }
        }

        if (isProdutoExiste) {
          palavras.addAll({
            lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]"))):
                produtoSelecionado
          });
        } else {
          await flutterTts.speak("Esse produto não existe");
        }
      } else if (lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]"))) ==
          'fornecedor') {
        bool isFornecedorExiste = false;
        String fornecedorSelecionado = "";
        if (produtoSelecionado != '') {
          print('Entro');
          print(lastWords.indexOf(RegExp(r"[ ]")));

          var lista2 = await crud.selectInner(
              tabela: "FornecedorProduto",
              select: 'Fornecedor!inner(Pessoa!inner(IdPessoa, Nome))',
              where: {
                'IdProduto': int.parse(produtoSelecionado.substring(
                    0, produtoSelecionado.indexOf(RegExp(r"[ ]"))))
              });
          print(lista2);
          if (lista != null) {
            for (var row in lista2) {
              fornecedores.add(
                  "${row["Fornecedor"]['Pessoa']["IdPessoa"]} ${row["Fornecedor"]['Pessoa']["Nome"]}");
            }
          }
          for (int i = 0; i < fornecedores.length; i++) {
            if (lastWords
                    .substring(
                        lastWords.indexOf(RegExp(r"[ ]")) + 1, lastWords.length)
                    .toLowerCase() ==
                fornecedores[i]
                    .substring(fornecedores[i].indexOf(RegExp(r"[ ]")) + 1,
                        fornecedores[i].length)
                    .toLowerCase()) {
              isFornecedorExiste = true;
              fornecedorSelecionado = fornecedores[i];
              break;
            }
          }

          if (isFornecedorExiste) {
            palavras.addAll({
              lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]"))):
                  fornecedorSelecionado
            });
          } else {
            await flutterTts.speak("Esse fornecedor não existe");
          }
        } else {
          await flutterTts.speak('Fale um produto primeiro');
        }
      } else {
        palavras.addAll({
          lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]"))):
              lastWords.substring(
                  lastWords.indexOf(RegExp(r"[ ]")) + 1, lastWords.length)
        });
      }
    } else {
      await flutterTts.speak("Campo invalido");
    }
    produtos.clear();
    notifyListeners();
  }

  void _logEvent(String eventDescription) {
    var eventTime = DateTime.now().toIso8601String();
    print('$eventTime $eventDescription');
  }

  Future<void> buscaComandos() async {
    List<dynamic> teste = await crud.selectComando(
        tabela: "Comando", select: "comando, acao", id: 1);
    comandos.clear();
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
    somEntrou();

    speech.listen(
        onResult: resultListener,
        listenFor: const Duration(seconds: 30),
        pauseFor: const Duration(milliseconds: 2000),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  Future<void> mensagem(String mensagem) async {
    await flutterTts.speak(mensagem);
  }
}
