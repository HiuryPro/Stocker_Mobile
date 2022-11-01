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
                Navigator.pushNamed(context, '/Home');
              }),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Venda'),
            subtitle: const Text('Tela de Venda'),
            onTap: () {
              Navigator.pushNamed(context, '/Venda');
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Compra'),
            subtitle: const Text('Tela de Compra'),
            onTap: () {
              Navigator.pushNamed(context, '/Compra');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configurações'),
            subtitle: const Text('Theme, Acessibilidade'),
            onTap: () {
              Navigator.pushNamed(context, '/Configuracoes');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            subtitle: const Text('Sair do Login'),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
        ],
      ),
    );
  }
}