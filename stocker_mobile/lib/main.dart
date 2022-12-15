import 'package:flutter/material.dart';
import 'package:stocker_mobile/teste2.dart';

import 'Validacao_e_Gambiarra/falapratexto.dart';
import 'Validacao_e_Gambiarra/textoprafala.dart';
import 'app_widget.dart';

main() async {
  runApp(const AppWidget());
  await Fala.instance.initTts();
  await Voz.instance.initSpeechState();
}
