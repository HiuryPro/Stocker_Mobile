import 'package:flutter/material.dart';
import 'package:stocker_mobile/Metodos_das_Telas/navegar.dart';

import 'app_controller.dart';

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
              navegar.navegarEntreTela('/home', context);
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
        ],
      ),
    );
  }
}
