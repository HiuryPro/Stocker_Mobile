import 'package:flutter/material.dart';

class Gambiarra extends ChangeNotifier {
  static Gambiarra gambiarra = Gambiarra();

  int loginAntigo = 0;
  String nomeNS = "";
  bool alteraTela = true;

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
