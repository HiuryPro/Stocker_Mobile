import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:stocker_mobile/Compra_e_Venda/tela_compra.dart';
import 'package:stocker_mobile/Compra_e_Venda/tela_venda.dart';
import 'package:stocker_mobile/Configuru%C3%A7%C3%B5es/configuracaotelas.dart';
import 'package:stocker_mobile/Login_e_Cadastro/cadastro_page.dart';
import 'package:stocker_mobile/Login_e_Cadastro/cadastro_usuario.dart';
import 'package:stocker_mobile/Produto_Estoque/cadastroproduto.dart';
import 'package:stocker_mobile/Cria_PDF/pega_imagem.dart';
import 'package:stocker_mobile/sttteste.dart';
import 'package:stocker_mobile/talkinh.dart';
import 'package:stocker_mobile/voice.dart';

import 'Cria_PDF/chart.dart';
import 'Validacao_e_Gambiarra/app_controller.dart';
import 'Login_e_Cadastro/atualiza_senha.dart';
import 'Home/home_page.dart';
import 'Login_e_Cadastro/login_page.dart';
import 'Login_e_Cadastro/nova_senha.dart';
import 'Login_e_Cadastro/novo_login.dart';

class Core extends StatelessWidget {
  const Core({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AppWidget();
  }
}

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
              localizationsDelegates: const [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
              ],
              supportedLocales: const [Locale('pt', 'BR')],
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  brightness: AppController.instance.isDarkTheme
                      ? Brightness.dark
                      : Brightness.light),
              initialRoute: '/home',
              routes: {
                '/': (context) => const LoginPage(),
                '/Cadastro': (context) => const CadPage(),
                '/home': (context) => const HomePage(),
                '/novologinpage': (context) => const NovoLoginPage(),
                '/novasenhapage': (context) => const NovaSenhaPage(),
                '/atualizasenha': (context) => const AtualizaSenha(),
                '/pegaimagem': (context) => const TesteImagem(),
                '/Compra': (context) => const Compra(),
                '/Voice': (context) => const TTSTeste(),
                '/talkin': (context) => const TalkinH(),
                '/Produto': (context) => const CadProduto(),
                '/Venda': (context) => const Venda(),
                '/CadastroUsuario': (context) => const CadUsuario(),
                '/Configuracoes': (context) => const Configuracoes()
              });
        });
  }
}
