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
  Map<String, String> palavrasVenda = {};
  Map<String, String> palavrasCompra = {};
  String fornecedorSelecionado = "";
  List<String> palavrasChavesCompra = [
    'produto',
    'quantidade',
    'fornecedor',
    'lote'
  ];
  List<String> palavrasChavesVenda = [
    'produto',
    'quantidade',
    'cliente',
    'adicional',
    'lote'
  ];
  int opcao = 0;
  late BuildContext context;
  String produtoSelecionadoCompra = "";
  String produtoSelecionadoVenda = "";

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
        if (opcao == 0) {
          await _comando();
        } else if (opcao == 1) {
          await _comando2();
        } else {
          await _comando3();
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
      Navigator.pushNamed(context, navegar2);
    } else {
      await flutterTts.speak("Esse Comando não existe");
    }
  }

//Compra
  Future _comando2() async {
    String? acao;
    bool isPalavraChave = false;
    List<String> produtos = [];
    List<String> fornecedores = [];
    Map<String, int> lotes = {};
    String? comando = lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]")));
    String? item = lastWords.substring(
        lastWords.indexOf(RegExp(r"[ ]")) + 1, lastWords.length);

    var lista = await crud.selectInner(
        tabela: "FornecedorProduto",
        select:
            'Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(Pessoa!inner(IdPessoa, Nome))',
        where: {});
    print(lista);

    if (lista != null) {
      for (var row in lista) {
        produtos.add(
            "${row["Produto"]["IdProduto"]} ${row["Produto"]["NomeProduto"]}");
      }
    }

    for (int i = 0; i < palavrasChavesCompra.length; i++) {
      print(comando.toLowerCase());
      if (comando.toLowerCase() == palavrasChavesCompra[i].toLowerCase()) {
        isPalavraChave = true;
        acao = palavrasChavesCompra[i];
        break;
      }
    }

    if (isPalavraChave) {
      await flutterTts.speak("$acao");

      if (comando.toLowerCase() == 'produto'.toLowerCase()) {
        bool isProdutoExiste = false;
        for (int i = 0; i < produtos.length; i++) {
          String produtoCompara = produtos[i]
              .substring(
                  produtos[i].indexOf(RegExp(r"[ ]")) + 1, produtos[i].length)
              .toLowerCase();
          if (item.toLowerCase() == produtoCompara) {
            isProdutoExiste = true;
            produtoSelecionadoCompra = produtos[i];

            break;
          }
        }

        if (isProdutoExiste) {
          palavrasCompra.addAll({comando: produtoSelecionadoCompra});
        } else {
          await flutterTts.speak("Esse produto não existe");
        }
      } else if (comando.toLowerCase() == 'fornecedor'.toLowerCase()) {
        bool isFornecedorExiste = false;

        print(produtoSelecionadoCompra);
        if (produtoSelecionadoCompra != '') {
          print(lastWords.indexOf(RegExp(r"[ ]")));

          var lista2 = await crud.selectInner(
              tabela: "FornecedorProduto",
              select: 'Fornecedor!inner(Pessoa!inner(IdPessoa, Nome))',
              where: {
                'IdProduto': int.parse(produtoSelecionadoCompra.substring(
                    0, produtoSelecionadoCompra.indexOf(RegExp(r"[ ]"))))
              });

          if (lista != null) {
            for (var row in lista2) {
              fornecedores.add(
                  "${row["Fornecedor"]['Pessoa']["IdPessoa"]} ${row["Fornecedor"]['Pessoa']["Nome"]}");
            }
          }
          for (int i = 0; i < fornecedores.length; i++) {
            String fornecedorCompara = fornecedores[i]
                .substring(fornecedores[i].indexOf(RegExp(r"[ ]")) + 1,
                    fornecedores[i].length)
                .toLowerCase();
            if (item.toLowerCase() == fornecedorCompara) {
              isFornecedorExiste = true;
              fornecedorSelecionado = fornecedores[i];
              break;
            }
          }

          if (isFornecedorExiste) {
            palavrasCompra.addAll({comando: fornecedorSelecionado});
          } else {
            await flutterTts.speak("Esse fornecedor não existe");
          }
        } else {
          await flutterTts.speak('Fale um produto primeiro');
        }
      } else if (comando.toLowerCase() == 'lote'.toLowerCase()) {
        print('entro');
        bool isLoteExiste = false;
        String loteSelecionado = "";
        print(produtoSelecionadoCompra);
        if (produtoSelecionadoCompra != '') {
          print(lastWords.indexOf(RegExp(r"[ ]")));
          print(produtoSelecionadoCompra.substring(
              produtoSelecionadoCompra.indexOf(RegExp(r"[ ]")) + 1,
              produtoSelecionadoCompra.length));
          print('agora');
          print(fornecedorSelecionado.substring(
              fornecedorSelecionado.indexOf(RegExp(r"[ ]")) + 1,
              fornecedorSelecionado.length));

          var lista2 = await crud.selectInner(
              tabela: "FornecedorPLote",
              select:
                  'Lote!inner(IdLote, NumeroLote), FornecedorProduto!inner(Produto!inner(NomeProduto), Fornecedor!inner(Pessoa!inner(IdPessoa, Nome)))',
              where: {
                'FornecedorProduto.Produto.NomeProduto':
                    produtoSelecionadoCompra.substring(
                        produtoSelecionadoCompra.indexOf(RegExp(r"[ ]")) + 1,
                        produtoSelecionadoCompra.length),
                'FornecedorProduto.Fornecedor.Pessoa.Nome':
                    fornecedorSelecionado.substring(
                        fornecedorSelecionado.indexOf(RegExp(r"[ ]")) + 1,
                        fornecedorSelecionado.length)
              });
          print(lista2);
          if (lista != null) {
            for (var row in lista2) {
              lotes.addAll({row['Lote']['NumeroLote']: row['Lote']['IdLote']});
            }
          }
          var listaLotes = lotes.keys.toList();
          print(listaLotes);

          for (int i = 0; i < listaLotes.length; i++) {
            if (item == listaLotes[i]) {
              isLoteExiste = true;
              loteSelecionado = listaLotes[i];
              break;
            }
          }

          if (isLoteExiste) {
            palavrasCompra.addAll({comando: loteSelecionado});
          } else {
            await flutterTts.speak("Esse fornecedor não existe");
          }
          produtoSelecionadoCompra = "";
        } else {
          await flutterTts.speak('Fale um produto primeiro');
        }
      } else {
        palavrasCompra.addAll({comando: item});
      }
    } else {
      await flutterTts.speak("Campo invalido");
    }
    produtos.clear();
    notifyListeners();
  }

//Venda
  Future _comando3() async {
    List<String> produtos = [];
    List<String> clientes = [];
    bool isPalavraChave = false;
    String comando = lastWords.substring(0, lastWords.indexOf(RegExp(r"[ ]")));
    String item = lastWords.substring(
        lastWords.indexOf(RegExp(r"[ ]")) + 1, lastWords.length);
    String? acao;

    var lista1 = await crud.selectInner(
        tabela: "Estoque",
        select: 'Produto!inner(IdProduto,NomeProduto)PrecoMPM',
        where: {});
    var lista2 = await crud.selectInner(
        tabela: "Cliente", select: 'Pessoa!inner(IdPessoa, Nome)', where: {});

    for (var row in lista1) {
      produtos.add(
          "${row['Produto']["IdProduto"]} ${row["Produto"]["NomeProduto"]}");
    }
    for (var row in lista2) {
      clientes.add("${row['Pessoa']['IdPessoa']} ${row['Pessoa']['Nome']}");
    }

    for (int i = 0; i < palavrasChavesVenda.length; i++) {
      print(comando);
      if (comando.toLowerCase() == palavrasChavesVenda[i].toLowerCase()) {
        isPalavraChave = true;
        acao = palavrasChavesVenda[i];
        break;
      }
    }

    if (isPalavraChave) {
      await flutterTts.speak("$acao");

      if (comando.toLowerCase() == "produto".toLowerCase()) {
        bool isProdutoExiste = false;

        for (int i = 0; i < produtos.length; i++) {
          String produtoCompara = produtos[i]
              .substring(
                  produtos[i].indexOf(RegExp(r"[ ]")) + 1, produtos[i].length)
              .toLowerCase();

          if (item.toLowerCase() == produtoCompara) {
            isProdutoExiste = true;
            produtoSelecionadoVenda = produtos[i];
            break;
          }
        }

        if (isProdutoExiste) {
          palavrasVenda.addAll({comando: produtoSelecionadoVenda});
          produtoSelecionadoVenda = "";
        } else {
          await flutterTts.speak("Esse produto não existe");
        }
      } else if (comando.toLowerCase() == "cliente".toLowerCase()) {
        bool isClienteExiste = false;
        String clienteSelecionado = "";
        for (int i = 0; i < clientes.length; i++) {
          String clienteCompara = clientes[i]
              .substring(
                  clientes[i].indexOf(RegExp(r"[ ]")) + 1, clientes[i].length)
              .toLowerCase();

          if (item.toLowerCase() == clienteCompara) {
            isClienteExiste = true;
            clienteSelecionado = clientes[i];
            break;
          }
        }

        if (isClienteExiste) {
          palavrasVenda.addAll({comando: clienteSelecionado});
        } else {
          await flutterTts.speak("Esse produto não existe");
        }
      } else {
        palavrasVenda.addAll({comando: item});
      }
    }

    produtos.clear();
    clientes.clear();
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
        pauseFor: const Duration(milliseconds: 2500),
        partialResults: true,
        localeId: _currentLocaleId,
        cancelOnError: true,
        listenMode: ListenMode.confirmation);
  }

  Future<void> mensagem(String mensagem) async {
    await flutterTts.speak(mensagem);
  }
}
