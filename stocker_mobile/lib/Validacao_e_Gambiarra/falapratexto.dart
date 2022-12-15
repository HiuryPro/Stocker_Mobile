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
  var crud = DataBaseService();
  late Navegar navegar;

  bool isEscutando = false;

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
    /*
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
    */
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
          print('Esse Produto não existe');
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
            print("Esse fornecedor não existe");
          }
        } else {
          print('Fale um produto primeiro');
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
            print("Esse lote não existe");
          }
          produtoSelecionadoCompra = "";
        } else {
          print('Fale um produto primeiro');
        }
      } else {
        palavrasCompra.addAll({comando: item});
      }
    } else {
      print("Campo invalido");
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
      print("$acao");

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
          print("Esse produto não existe");
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
          print("Esse produto não existe");
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

  Future<void> mensagem(String mensagem) async {
    print(mensagem);
  }
}
