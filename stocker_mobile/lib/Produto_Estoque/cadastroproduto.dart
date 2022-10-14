import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
