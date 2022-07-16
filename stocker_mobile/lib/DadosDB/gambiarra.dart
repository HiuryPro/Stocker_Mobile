import 'package:flutter/material.dart';

class Gambiarra extends ChangeNotifier {
  static Gambiarra gambiarra = Gambiarra();

  int loginAntigo = 0;

  mudaLogin(int loginN) {
    loginAntigo = loginN;
  }
}
