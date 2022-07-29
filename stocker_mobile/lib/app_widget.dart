import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'Cria_PDF/chart.dart';
import 'Validacao_e_Gambiarra/app_controller.dart';
import 'Login_e_Cadastro/atualiza_senha.dart';
import 'Login_e_Cadastro/cadastro_page.dart';
import 'Home/home_page.dart';
import 'Login_e_Cadastro/login_page.dart';
import 'Login_e_Cadastro/nova_senha.dart';
import 'Login_e_Cadastro/novo_login.dart';

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
              initialRoute: '/homepage',
              routes: {
                '/': (context) => const LoginPage(),
                '/homepage': (context) => const HomePage(),
                '/cadpage': (context) => const CadPage(),
                '/novologinpage': (context) => const NovoLoginPage(),
                '/novasenhapage': (context) => const NovaSenhaPage(),
                '/atualizasenha': (context) => const AtualizaSenha(),
                '/pdf': (context) => const Chart(),
              });
        });
  }
}
