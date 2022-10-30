import 'package:flutter/material.dart';
import 'package:stocker_mobile/Metodos_das_Telas/navegar.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/teste4.dart';

import 'app_controller.dart';
import 'argumentosVoz.dart';

class DrawerTela {
  var navegar = Navegar();
  var teste = AppController;

  Drawer drawerTela(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Image.asset(AppController.instance.background),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            subtitle: const Text('Tela de Inicio'),
            onTap: () {
              navegar.navegarEntreTela('/Home', context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Venda'),
            subtitle: const Text('Tela de Venda'),
            onTap: () {
              navegar.navegarEntreTela('/Venda', context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Compra'),
            subtitle: const Text('Tela de Compra'),
            onTap: () {
              navegar.navegarEntreTela('/Compra', context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            subtitle: const Text('Theme, Acessibilidade'),
            onTap: () {
              navegar.navegarEntreTela('/Configuracoes', context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            subtitle: const Text('Sair do Login'),
            onTap: () {
              navegar.navegarEntreTela('/', context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.bug_report),
            title: const Text('Teste'),
            subtitle: const Text('Testando o App depois nos tira'),
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  TesteFrog.nomeDaRota, (Route<dynamic> route) => false,
                  arguments: ScreenArguments(MyPage()));
            },
          ),
        ],
      ),
    );
  }
}
