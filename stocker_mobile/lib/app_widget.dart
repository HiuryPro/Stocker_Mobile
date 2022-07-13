import 'package:flutter/material.dart';
import 'package:stocker_mobile/cadastro_page.dart';
import 'app_controller.dart';
import 'home_page.dart';
import 'login_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: AppController.instance,
        builder: (context, child) {
          return MaterialApp(
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  brightness: AppController.instance.isDarkTheme
                      ? Brightness.dark
                      : Brightness.light),
              routes: {
                '/': (context) => const LoginPage(),
                '/homepage': (context) => const HomePage(),
                '/cadpage': (context) => const CadPage()
              });
        });
  }
}
