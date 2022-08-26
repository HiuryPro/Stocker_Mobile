import 'package:flutter/material.dart';

class Navegar {
  navegarEntreTela(String rota, var context) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(rota, (Route<dynamic> route) => false);
  }
}
