import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

class CadProduto extends StatefulWidget {
  const CadProduto({super.key});

  @override
  State<CadProduto> createState() => _CadProdutoState();
}

class _CadProdutoState extends State<CadProduto> {
  TextEditingController controllerProduto = TextEditingController();
  TextEditingController controllerQtd = TextEditingController();
  TextEditingController controllerPrecoUnd = TextEditingController();
  TextEditingController controllerDescricao = TextEditingController();
  var crud = DataBaseService();

  clearCampos() {
    controllerProduto.clear();
    controllerQtd.clear();
    controllerPrecoUnd.clear();
    controllerDescricao.clear();
  }

  Widget body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: ListView(shrinkWrap: true, children: [
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
              controller: controllerDescricao,
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              decoration: const InputDecoration(
                label: Text('Descrição'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () async {
                  var idEmpresa = await crud
                      .select(tabela: 'Empresa', select: 'IdEmpresa', where: {
                    'IdAdministrador': AppController.instance.response!.user!.id
                  });
                  print(idEmpresa);
                  var responseProduto =
                      await crud.insert(tabela: 'Produto', map: {
                    'NomeProduto': controllerProduto.text,
                    'Descricao': controllerDescricao.text,
                    'IdEmpresa': idEmpresa[0]['IdEmpresa']
                  });
                  print(responseProduto);
                  await crud.insert(tabela: 'Estoque', map: {
                    'IdProduto': responseProduto['IdProduto'],
                    'Quantidade': int.parse(controllerQtd.text),
                    'PrecoMPM': int.parse(controllerPrecoUnd.text)
                  });

                  clearCampos();
                },
                child: const Text('Cadastrar Produto'))
          ]))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }
}
