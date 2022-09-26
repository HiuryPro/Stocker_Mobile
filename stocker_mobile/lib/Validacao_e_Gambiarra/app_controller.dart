import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDarkTheme = false;
  String background = "assets/images/back2.jpg";
  String logo = "assets/images/Stocker_blue_transpN.png";
  Color theme1 = Colors.black;
  Color theme2 = const Color(0xFF0080d9);

  GotrueSessionResponse? response;

  int loginAntigo = 0;
  String nomeNS = "";
  bool alteraTela = true;

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    if (isDarkTheme) {
      background = "assets/images/back2B.jpg";
      logo = "assets/images/Stocker_blue_transpNBpng";
      theme1 = Colors.white;
      theme2 = const Color(0xFFff7f26);
    } else {
      background = "assets/images/back2.jpg";
      logo = "assets/images/Stocker_blue_transpN.png";
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
