import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDarkTheme = false;
  String img = "assets/images/back2.jpg";
  String img2 = "assets/images/Stocker_blue_transp.png";
  Color theme1 = Colors.black;
  Color theme2 = const Color(0xFF0080d9);

  int loginAntigo = 0;
  String nomeNS = "";
  bool alteraTela = true;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    if (isDarkTheme) {
      img = "assets/images/backblack.jpg";
      img2 = "assets/images/Stocker_blue_transpblack.png";
      theme1 = Colors.white;
      theme2 = const Color(0xFFff7f26);
    } else {
      img = "assets/images/back2.jpg";
      img2 = "assets/images/Stocker_blue_transp.png";
      theme1 = Colors.black;
      theme2 = const Color(0xFF0080d9);
    }
    notifyListeners();
  }

  mudaLogin(int loginN) {
    loginAntigo = loginN;
  }

  pegaNome(String nome) {
    nomeNS = nome;
  }

  setAlteraT(bool muda) {
    alteraTela = muda;
  }
}
