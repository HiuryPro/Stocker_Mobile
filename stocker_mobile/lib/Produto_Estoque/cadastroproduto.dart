import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/drawertela.dart';
import 'package:stocker_mobile/credentials/supabase.credentials.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';
import 'package:universal_html/html.dart';

import '../Validacao_e_Gambiarra/voz.dart';

class CadProduto extends StatefulWidget {
  const CadProduto({super.key});

  @override
  State<CadProduto> createState() => _CadProdutoState();
}

class _CadProdutoState extends State<CadProduto> {
  TextEditingController controllerProduto = TextEditingController();
  TextEditingController controllerQtd = TextEditingController();
  TextEditingController controllerPrecoUnd = TextEditingController();
  TextEditingController controllerDescricaoProduto = TextEditingController();
  TextEditingController controllerDescricaoLote = TextEditingController();
  TextEditingController controllerNumLote = TextEditingController();
  TextEditingController controllerDataVencimento = TextEditingController();
  TextEditingController controllerDataFabricacao = TextEditingController();

  bool isDataDeVencimento = true;
  bool isDataDeFabricacao = true;
  final produtos = [""];
  String? produto;

  var drawerTela = DrawerTela();

  var dateMaskFabricacao = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var dateMaskVencimento = MaskTextInputFormatter(
      mask: '##/##/####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var crud = DataBaseService();

  clearCamposProduto() {
    controllerProduto.clear();
    controllerDescricaoProduto.clear();
  }

  clearCamposLote() {
    controllerNumLote.clear();
    controllerQtd.clear();
    controllerPrecoUnd.clear();
    controllerDescricaoLote.clear();
    controllerDataFabricacao.clear();
    controllerDataVencimento.clear();
  }

// DateFormat("dd/MM/yyyy").parse('28/12/2002');

  @override
  void initState() {
    produtos.clear();
    super.initState();
    Future.delayed(Duration.zero, () async {
      if (kIsWeb) {
        await window.navigator.getUserMedia(audio: true);
      } else {
        if (!await Permission.microphone.isGranted) {
          await Permission.microphone.request();
        }
      }

      var lista = await crud.selectInner(
          tabela: "Produto", select: 'IdProduto, NomeProduto', where: {});
      print(lista);
      if (lista != null) {
        setState(() {
          for (var row in lista) {
            produtos.add("${row["IdProduto"]} ${row["NomeProduto"]}");
          }
        });
      }
    });
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: ListView(shrinkWrap: true, children: [
            const Text('Cadastro de Produto', style: TextStyle(fontSize: 30)),
            const SizedBox(
              height: 15,
            ),
            TextField(
                controller: controllerProduto,
                inputFormatters: [],
                decoration: const InputDecoration(
                  label: Text('Produto'),
                  border: OutlineInputBorder(),
                )),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllerDescricaoProduto,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                label: Text('Descrição'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () async {
                  print(AppController.instance.response!.user!.id);
                  print(
                      SupaBaseCredentials.supaBaseClient.auth.currentUser!.id);
                  var idEmpresa = await crud
                      .select(tabela: 'Empresa', select: 'IdEmpresa', where: {
                    'IdAdministrador': AppController.instance.response!.user!.id
                  });
                  print(idEmpresa);
                  var responseProduto =
                      await crud.insert(tabela: 'Produto', map: {
                    'NomeProduto': controllerProduto.text,
                    'Descricao': controllerDescricaoProduto.text,
                    'IdEmpresa': idEmpresa[0]['IdEmpresa']
                  });
                  setState(() {
                    produtos.clear();
                  });
                  print(responseProduto);
                  var lista = await crud.selectInner(
                      tabela: "Produto",
                      select: 'IdProduto, NomeProduto',
                      where: {});
                  print(lista);
                  if (lista != null) {
                    setState(() {
                      for (var row in lista) {
                        produtos
                            .add("${row["IdProduto"]} ${row["NomeProduto"]}");
                      }
                    });
                  }

                  clearCamposProduto();
                },
                child: const Text('Cadastrar Produto')),
            const SizedBox(
              height: 30,
            ),
            const Text('Cadastro de Lote', style: TextStyle(fontSize: 30)),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0080d9), width: 2),
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
                    onChanged: (value) async {}),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
                controller: controllerNumLote,
                decoration: const InputDecoration(
                  label: Text('Número do Lote'),
                  border: OutlineInputBorder(),
                )),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllerQtd,
              decoration: const InputDecoration(
                label: Text("Quantidade"),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllerPrecoUnd,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Preco Unitário',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              inputFormatters: [dateMaskFabricacao],
              enabled: isDataDeFabricacao,
              controller: controllerDataFabricacao,
              decoration: const InputDecoration(
                  label: Text('Data de Fabricação'),
                  border: OutlineInputBorder()),
            ),
            Row(
              children: [
                Checkbox(
                    value: !isDataDeFabricacao,
                    onChanged: (valor) {
                      setState(() {
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
              inputFormatters: [dateMaskVencimento],
              enabled: isDataDeVencimento,
              controller: controllerDataVencimento,
              decoration: const InputDecoration(
                  label: Text('Data de Vencimento'),
                  border: OutlineInputBorder()),
            ),
            Row(
              children: [
                Checkbox(
                    value: !isDataDeVencimento,
                    onChanged: (valor) {
                      setState(() {
                        isDataDeVencimento = !isDataDeVencimento;
                      });
                    }),
                const Text('Caso não haja data de vencimento')
              ],
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllerDescricaoLote,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                label: Text('Descrição do Lote'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {}, child: const Text('Cadastrar Lote')),
          ]))),
    );
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
    return Scaffold(
        extendBodyBehindAppBar: true,
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.phone),
            onPressed: () async {
              print(this.context);
              Voz.instance.opcao = 0;
              Voz.instance.context = this.context;
              await Voz.instance.initSpeechState();

              await Voz.instance.initTts();
              await Voz.instance.buscaComandos();

              Voz.instance.startListening();

              //  navegar.navegarEntreTela(voz.navegar, context);
            }),
        appBar: AppBar(
          foregroundColor: AppController.instance.theme1,
          shadowColor: Colors.transparent,
          backgroundColor: Colors.transparent,
        ),
        drawer: drawerTela.drawerTela(context),
        body: body());
  }
}
