import 'package:flutter/material.dart';

import 'package:stocker_mobile/Validacao_e_Gambiarra/drawertela.dart';

import '../Validacao_e_Gambiarra/voz.dart';

class Estoque extends StatefulWidget {
  const Estoque({super.key});

  @override
  State<Estoque> createState() => _EstoqueState();
}

class _EstoqueState extends State<Estoque> {
  var drawerTela = DrawerTela();

  Widget body() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: ListView(
            shrinkWrap: true,
            children: [Text("Funciona")],
          )),
        ));
  }

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
                      child: Icon(Icons.hearing),
                      onPressed: () async {
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
                      child: Icon(Icons.phone),
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
              body: body());
        });
  }
}
