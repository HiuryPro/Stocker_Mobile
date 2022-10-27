import 'package:flutter/material.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/app_controller.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/drawertela.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/voz.dart';

import '../Metodos_das_Telas/navegar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var drawerTela = DrawerTela();
  var navegar = Navegar();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      floatingActionButton: const ReconheceVoz(),
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
