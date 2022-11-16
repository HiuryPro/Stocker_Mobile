import 'dart:io' as plataforma;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:universal_html/html.dart';
import '../Metodos_das_Telas/navegar.dart';
import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/drawertela.dart';
import '../Validacao_e_Gambiarra/voz.dart';
import '../services/supabase.databaseService.dart';
// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class Compra extends StatefulWidget {
  const Compra({Key? key}) : super(key: key);

  @override
  State<Compra> createState() => _CompraState();
}

class _CompraState extends State<Compra> {
  var drawerTela = DrawerTela();

  var fieldControllerTotal = TextEditingController();

  Map<String, TextEditingController> controllersCompra = {
    'preco': TextEditingController(),
    'frete': TextEditingController(),
    'qtd': TextEditingController()
  };

  Map<String, TextEditingController> controllersLote = {
    'numeroLote': TextEditingController(),
    'quantidade': TextEditingController(),
    'precoUnd': TextEditingController(),
    'descricao': TextEditingController(),
    'dataVencimento': TextEditingController(),
    'dataFabricacao': TextEditingController()
  };

  var crud = DataBaseService();
  final produtos = [""];
  final fornecedores = [""];
  String? produto;
  String? fornecedor;
  int? quantidade;
  double? preco;
  double? frete;
  double? total;
  int quantidadeLinhas = 0;
  List<bool> selecionado = [];
  List<Map> preCompra = [];
  Map<String, int> lotes = {};
  String? lote;

  bool valor = true;
  bool valor2 = true;
  bool valor3 = true;

  bool isDataDeVencimento = true;
  bool isDataDeFabricacao = true;

  bool isLoteExistente = true;

  var dateMaskFabricacao = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateMaskVencimento = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    produtos.clear();
    print('Funciona inferno');
    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }
      var listaLotes = await crud
          .select(tabela: "Lote", select: 'IdLote, NumeroLote', where: {});
      if (listaLotes != null) {
        for (var row in listaLotes) {
          lotes.addAll({row['NumeroLote']: row['IdLote']});
        }
      }

      var lista = await crud.selectInner(
          tabela: "FornecedorProduto",
          select:
              'Preco, Frete, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(Pessoa!inner(IdPessoa, Nome))',
          where: {});
      print(lista);
      if (lista != null) {
        setState(() {
          for (var row in lista) {
            produtos.add(
                "${row["Produto"]["IdProduto"]} ${row["Produto"]["NomeProduto"]}");
          }
        });
      }
    });
  }

  int apenasNumeros(String idNoText) {
    String soId = idNoText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(soId);
  }

  adicionaF(var palavras) async {
    var lista = [];

    print(palavras['produto']);
    print(apenasNumeros(palavras['produto']!));
    lista = await crud.selectInner(
        tabela: "FornecedorProduto",
        select:
            'Fornecedor!inner(Pessoa!inner(IdPessoa, Nome)), Produto!inner(IdProduto, NomeProduto)',
        where: {"Produto.IdProduto": apenasNumeros(palavras['produto']!)});
    setState(() {
      valor = false;
      controllersCompra['preco']!.text = "";
      produto = palavras['produto'];
      fornecedor = null;
      fornecedores.clear();
      for (var row in lista) {
        fornecedores.add(
            "${row['Fornecedor']['Pessoa']['IdPessoa']} ${row['Fornecedor']['Pessoa']['Nome']}");
      }
    });
  }

  adicionaPreco(var palavras) async {
    var lista = await crud.selectInner(
        tabela: "FornecedorProduto",
        select:
            '*, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(IdFornecedor)',
        where: {
          "Produto.IdProduto": apenasNumeros(palavras['produto']),
          "Fornecedor.IdFornecedor": apenasNumeros(palavras['fornecedor'])
        });
    print(lista);
    for (var row in lista) {
      setState(() {
        valor2 = false;
        fornecedor = palavras['fornecedor'];
        controllersCompra['preco']!.text = row['Preco'].toString();
        controllersCompra['frete']!.text = row['Frete'].toString();
        preco = double.parse(controllersCompra['preco']!.text);
        frete = double.parse(controllersCompra['frete']!.text);
        calculaTotal();
      });
    }
  }

  adicionaQtd(var palavras) async {
    setState(() {
      valor3 = false;
    });

    if (palavras['quantidade']!.contains(RegExp(r'[A-Za-z]'))) {
      await Voz.instance
          .mensagem('Erro ao gravar Quantidade. Tente falar novamente');
      Voz.instance.palavrasCompra.remove('quantidade');
    } else {
      controllersCompra['qtd']!.text = palavras['quantidade']!;
      calculaTotal();
    }
  }

  calculaTotal() {
    if (controllersCompra['qtd']!.text != "" &&
        controllersCompra['frete']!.text != "" &&
        controllersCompra['preco']!.text != "") {
      quantidade = int.parse(controllersCompra['qtd']!.text);
      setState(() {
        fieldControllerTotal.text =
            ((quantidade! * preco!) + frete!).toString();
        total = double.parse(fieldControllerTotal.text);
      });
    } else {
      fieldControllerTotal.text = "";
    }
  }

  Widget body(int lastWords, Map<String, String> palavras) {
    Future.delayed(Duration.zero, () async {
      if (palavras.containsKey('produto') &&
          !palavras.containsKey('fornecedor') &&
          valor) {
        produto = palavras['produto'];
        await adicionaF(palavras);
      }

      if (palavras.containsKey('fornecedor') &&
          palavras.containsKey('produto') &&
          valor2) {
        fornecedor = palavras['fornecedor'];
        await adicionaPreco(palavras);
      }

      if (palavras.containsKey('quantidade') && valor3) {
        await adicionaQtd(palavras);
      }
    });

    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ListView(shrinkWrap: true, children: [
              Text(palavras.toString()),
              const SizedBox(height: 15),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: produto,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Produtos"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: produtos.map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        var lista = [];
                        setState(() {
                          produto = value;

                          controllersCompra['preco']!.text = "";
                          fornecedor = null;
                        });
                        print(produto);
                        lista = await crud.selectInner(
                            tabela: "FornecedorProduto",
                            select:
                                'Fornecedor!inner(Pessoa!inner(IdPessoa, Nome)), Produto!inner(IdProduto, NomeProduto)',
                            where: {
                              "Produto.IdProduto": apenasNumeros(produto!)
                            });
                        setState(() {
                          fornecedores.clear();
                          for (var row in lista) {
                            fornecedores.add(
                                "${row['Fornecedor']['Pessoa']['IdPessoa']} ${row['Fornecedor']['Pessoa']['Nome']}");
                          }
                        });
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: fornecedor,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Fornecedores"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: fornecedores.map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          fornecedor = value;
                        });
                        print(fornecedor);
                        var lista = await crud.selectInner(
                            tabela: "FornecedorProduto",
                            select:
                                '*, Produto!inner(IdProduto, NomeProduto), Fornecedor!inner(IdFornecedor)',
                            where: {
                              "Produto.IdProduto": int.parse(produto![0]),
                              "Fornecedor.IdFornecedor":
                                  int.parse(fornecedor![0])
                            });
                        print(lista);
                        for (var row in lista) {
                          setState(() {
                            controllersCompra['preco']!.text =
                                row['Preco'].toString();
                            controllersCompra['frete']!.text =
                                row['Frete'].toString();
                            preco =
                                double.parse(controllersCompra['preco']!.text);
                            frete =
                                double.parse(controllersCompra['frete']!.text);
                          });
                        }
                      }),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: lote,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Número de Lote"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: lotes.keys.toList().map(buildMenuItem).toList(),
                      onChanged: isLoteExistente
                          ? (value) async {
                              var lista = [];
                              setState(() {
                                lote = value;
                              });
                            }
                          : null),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                      value: !isLoteExistente,
                      onChanged: (value) {
                        setState(() {
                          isLoteExistente = !isLoteExistente;
                        });
                      }),
                  const Text("Marcar caso necessario cadastrar novo Lote"),
                ],
              ),
              if (isLoteExistente) const SizedBox(height: 15),
              if (!isLoteExistente)
                for (int i = 0; i < fieldsLote().length; i++) fieldsLote()[i],
              TextField(
                controller: controllersCompra['qtd']!,
                onChanged: (qtd) {
                  setState(() {
                    if (Voz.instance.palavrasCompra.containsKey('quantidade')) {
                      Voz.instance.palavrasCompra.remove('quantidade');
                    }

                    if (qtd != "") {
                      quantidade = int.parse(qtd);
                      fieldControllerTotal.text =
                          ((quantidade! * preco!) + frete!).toString();
                      total = double.parse(fieldControllerTotal.text);
                    } else {
                      quantidade = 0;
                      fieldControllerTotal.text = "";
                    }
                  });
                },
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                    labelText: "Quantidade",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                enabled: false,
                controller: controllersCompra['preco']!,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Preço",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                enabled: false,
                controller: controllersCompra['frete']!,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Frete",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 15,
              ),
              TextField(
                enabled: false,
                controller: fieldControllerTotal,
                onChanged: (text) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    labelText: "Total",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                            color: Color(0xFF0080d9), width: 2))),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    print(preCompra);
                    bool isPreechido = true;

                    if (!isLoteExistente) {
                      await casdastroLote();
                    } else {}
                    adicionaPreCompra();

                    setState(() {
                      controllersCompra['qtd']!.text = "";
                      fieldControllerTotal.text = "";
                      controllersCompra['frete']!.text = "";
                      controllersCompra['preco']!.text = "";
                      fornecedor = null;
                      produto = null;
                    });

                    if (Voz.instance.palavrasCompra.isNotEmpty) {
                      Voz.instance.palavrasCompra.clear();
                    }
                  },
                  child: const Text("Adiciona Linha")),
              ListView(
                shrinkWrap: true,
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                          columns: _createColumns(), rows: createRows()))
                ],
              ),
              const SizedBox(height: 15),
              const SizedBox(height: 15),
              ElevatedButton(
                  onPressed: () {
                    print(preCompra);
                    print(selecionado);
                    print(vaiComprar());
                  },
                  child: const Text("Imprimi")),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                  onPressed: () async {
                    List<Map<dynamic, dynamic>?> dados = vaiComprar();
                    var insertCompra =
                        await crud.insert(tabela: 'Compra', map: {
                      'DataCompra':
                          DateFormat.yMMMd().add_Hm().format(DateTime.now()),
                      'HoraCompra': DateFormat.Hms().format(DateTime.now())
                    });

                    for (int i = 0; i < dados.length; i++) {
                      var id = await crud.select(
                          tabela: 'FornecedorProduto',
                          select: 'IdFornecedorProduto',
                          where: {
                            'IdFornecedor':
                                apenasNumeros(dados[i]!['fornecedor']),
                            'IdProduto': apenasNumeros(dados[i]!['produto'])
                          });
                      await crud.insert(tabela: 'ItemCompra', map: {
                        'IdCompra': insertCompra[0]['IdCompra'],
                        'IdFornecedorProduto': id[0]['IdFornecedorProduto'],
                        'Quantidade': dados[i]!['quantidade'],
                        'PrecoCompra': dados[i]!['preco'],
                        'FreteCompra': dados[i]!['frete']
                      });
                    }
                    setState(() {
                      preCompra.clear();
                      fieldControllerTotal.text = "";
                    });
                  },
                  child: const Text("Comprar"))
            ]))));
  }

  casdastroLote() async {
    bool isTudoPreenchido = true;
    bool isExistente = false;

    controllersLote.forEach((key, value) {
      if (value.text == '') {
        setState(() {
          print(key);
          if ((key == 'dataFabricacao' && !isDataDeFabricacao) ||
              (key == 'dataVencimento' && !isDataDeVencimento)) {
            print('Entro');
          } else {
            //mensagemDeErroLote[key] = 'Campo está vazio';
            isTudoPreenchido = false;
            print(value.text);
          }
        });
      }
    });

    if (isTudoPreenchido && produto != null && fornecedor != null) {
      var loteResultado;
      var produtos = await crud.selectInner(
          tabela: 'Lote', select: 'NumeroLote, IdProduto', where: {});

      for (var row in produtos) {
        if (row['IdProduto'] == apenasNumeros(produto!) &&
            row['NumeroLote'] == controllersLote['numeroLote']!.text) {
          isExistente = true;
        }
      }
      if (!isExistente) {
        if (isDataDeFabricacao && isDataDeVencimento) {
          loteResultado = await crud.insert(tabela: 'Lote', map: {
            'NumeroLote': controllersLote['numeroLote']!.text,
            'IdProduto': apenasNumeros(produto!),
            'DataVencimento': DateFormat.yMMMd().add_Hm().format(
                DateFormat("dd/MM/yyyy")
                    .parse(dateMaskVencimento.getMaskedText())),
            'DataFabricacao': DateFormat.yMMMd().add_Hm().format(
                DateFormat("dd/MM/yyyy")
                    .parse(dateMaskFabricacao.getMaskedText())),
            'Descricao': controllersLote['descricao']!.text,
          });
          print(loteResultado);
          print(DateFormat("dd/MM/yyyy")
              .parse(dateMaskFabricacao.getMaskedText()));
        } else if (isDataDeFabricacao) {
          loteResultado = await crud.insert(tabela: 'Lote', map: {
            'NumeroLote': int.parse(controllersLote['numeroLote']!.text),
            'IdProduto': apenasNumeros(produto!),
            'DataFabricacao': DateFormat.yMMMd().add_Hm().format(
                DateFormat("dd/MM/yyyy")
                    .parse(dateMaskFabricacao.getMaskedText())),
            'Descricao': controllersLote['descricao']!.text,
          });
          print(loteResultado);
        } else if (isDataDeVencimento) {
          loteResultado = await crud.insert(tabela: 'Lote', map: {
            'NumeroLote': int.parse(controllersLote['numeroLote']!.text),
            'IdProduto': apenasNumeros(produto!),
            'DataVencimento': DateFormat.yMMMd().add_Hm().format(
                DateFormat("dd/MM/yyyy")
                    .parse(dateMaskVencimento.getMaskedText())),
            'Descricao': controllersLote['descricao']!.text,
          });
          print(loteResultado);
        } else {
          loteResultado = await crud.insert(tabela: 'Lote', map: {
            'NumeroLote': int.parse(controllersLote['numeroLote']!.text),
            'IdProduto': apenasNumeros(produto!),
            'Descricao': controllersLote['descricao']!.text,
          });
          print(loteResultado);
        }
        var estoqueResultado = await crud.insert(tabela: 'Estoque', map: {
          'IdLote': loteResultado[0]['IdLote'],
          'Quantidade': int.parse(controllersLote['quantidade']!.text),
          'PrecoMPM': double.parse(controllersLote['precoUnd']!.text)
        });
        print(estoqueResultado);
        var snack = const SnackBar(
          content: Text('Cadastro de lote feito com sucesso'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      } else {
        var snack = const SnackBar(
          content: Text(
              'Esse Lote já existe. Vá para a tela de Estoque para alterar lote'),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
        setState(() {
          produto = null;
          controllersLote['numeroLote']!.text = "";
        });
      }
    } else {
      var snack = const SnackBar(
        content: Text('Há campos vazios'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    }
  }

  List<Widget> fieldsLote() {
    return [
      const SizedBox(
        height: 30,
      ),
      TextField(
        controller: controllersLote['numeroLote'],
        decoration: InputDecoration(
            label: const Text('Numero Do Lote'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF0080d9), width: 2))),
      ),
      const SizedBox(
        height: 15,
      ),
      TextField(
        enabled: isDataDeFabricacao,
        controller: controllersLote['dataFabricacao'],
        inputFormatters: [dateMaskFabricacao],
        decoration: InputDecoration(
            label: const Text('Data de Fabricação'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF0080d9), width: 2))),
      ),
      Row(
        children: [
          Checkbox(
              value: !isDataDeFabricacao,
              onChanged: (valor) {
                setState(() {
                  //   mensagemDeErroLote['dataFabricacao'] = null;
                  isDataDeFabricacao = !isDataDeFabricacao;
                });
              }),
          const Text('Caso não haja data de fabricação')
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      TextField(
        enabled: isDataDeVencimento,
        controller: controllersLote['dataVencimento'],
        inputFormatters: [dateMaskVencimento],
        decoration: InputDecoration(
            label: const Text('Data de Vencimento'),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                    const BorderSide(color: Color(0xFF0080d9), width: 2))),
      ),
      Row(
        children: [
          Checkbox(
              value: !isDataDeVencimento,
              onChanged: (valor) {
                setState(() {
                  //   mensagemDeErroLote['dataVencimento'] = null;
                  isDataDeVencimento = !isDataDeVencimento;
                });
              }),
          const Text('Caso não haja data de vencimento')
        ],
      ),
      const SizedBox(
        height: 15,
      ),
      TextField(
        controller: controllersLote['descricao'],
        maxLines: 4,
        keyboardType: TextInputType.multiline,
        decoration: const InputDecoration(
          label: Text('Descrição do Lote'),
          border: OutlineInputBorder(),
        ),
      ),
      const SizedBox(
        height: 45,
      ),
    ];
  }

  void adicionaPreCompra() {
    bool podeAdicionar = true;
    setState(() {
      for (int i = 0; i < preCompra.length; i++) {
        if (preCompra[i].containsValue(fornecedor) &&
            preCompra[i].containsValue(produto)) {
          podeAdicionar = false;
          break;
        }
      }
      if (podeAdicionar) {
        preCompra.add({
          'produto': produto,
          'fornecedor': fornecedor,
          'quantidade': quantidade,
          'preco': preco,
          'frete': frete
        });
        selecionado.add(true);
      }
    });
    print(preCompra);
  }

  List<Map<dynamic, dynamic>?> vaiComprar() {
    List<Map<dynamic, dynamic>?> lista = [];
    for (int i = 0; i < preCompra.length; i++) {
      if (selecionado[i] == true) {
        lista.add(preCompra[i]);
      }
    }
    lista.removeWhere((element) => element == null);
    return lista;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(item,
            style: const TextStyle(
              fontSize: 20,
            )),
      ));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Voz.instance,
        builder: (context, snapshot) {
          return Scaffold(
              floatingActionButton: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  FloatingActionButton(
                      heroTag: null,
                      child: const Icon(Icons.hearing),
                      onPressed: () async {
                        setState(() {
                          valor = true;
                          valor2 = true;
                          valor3 = true;
                        });
                        print(this.context);
                        Voz.instance.opcao = 1;
                        Voz.instance.context = this.context;
                        await Voz.instance.initSpeechState();
                        await Voz.instance.initTts();
                        await Voz.instance.buscaComandos();
                        Voz.instance.startListening();
                      }),
                  FloatingActionButton(
                      heroTag: null,
                      child: const Icon(Icons.phone),
                      onPressed: () async {
                        print(this.context);
                        Voz.instance.context = this.context;
                        Voz.instance.opcao = 0;
                        await Voz.instance.initSpeechState();

                        await Voz.instance.initTts();
                        await Voz.instance.buscaComandos();
                        Voz.instance.startListening();
                      })
                ],
              ),
              drawer: drawerTela.drawerTela(context),
              appBar: AppBar(),
              body: body(Voz.instance.palavrasCompra.length,
                  Voz.instance.palavrasCompra));
        });
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text('Fornecedor')),
      DataColumn(label: Text('Quantidade')),
      DataColumn(label: Text('Preco')),
      DataColumn(label: Text('Frete')),
      DataColumn(label: Text('Total')),
    ];
  }

  List<DataRow> createRows() {
    return preCompra
        .mapIndexed((index, book) => DataRow(
                cells: [
                  DataCell(Text(book['produto'])),
                  DataCell(Text(book['fornecedor'])),
                  DataCell(TextFormField(
                    initialValue: "${book['quantidade']}",
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      setState(() {
                        if (text != '') {
                          book['quantidade'] = int.parse(text);
                        } else {
                          book['quantidade'] = 0;
                        }
                      });
                    },
                  )),
                  DataCell(Text("${book['preco']}")),
                  DataCell(Text("${book['frete']}")),
                  DataCell(Text(
                      "${(book['quantidade'] * book['preco']) + book['frete']}"))
                ],
                selected: selecionado[index],
                onSelectChanged: (bool? selected) {
                  setState(() {
                    selecionado[index] = selected!;
                    print(preCompra);
                  });
                }))
        .toList();
  }
}
