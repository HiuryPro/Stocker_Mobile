import 'package:flutter/material.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

import '../Validacao_e_Gambiarra/textoprafala.dart';

class Navegar {
  static var instance = Navegar();
  var crud = DataBaseService();
  Map<String, String> comandos = {};

  Future navegar(String falou, BuildContext context) async {
    String navegar2 = '';
    List<String> comandosDados = comandos.keys.toList();
    String? acao;
    bool isComandoExistente = false;
    for (int i = 0; i < comandosDados.length; i++) {
      if (falou.toLowerCase() == comandosDados[i].toLowerCase()) {
        isComandoExistente = true;
        acao = comandos[comandosDados[i]];
        break;
      }
    }

    if (isComandoExistente) {
      await Fala.instance.flutterTts.speak("Tela ${acao!}");
      navegar2 = "/$acao";
      Navigator.pushNamed(context, navegar2);
    } else {}
  }

  Future<void> buscaComandos() async {
    List<dynamic> teste = await crud.selectComando(
        tabela: "Comando", select: "comando, acao", id: 1);
    comandos.clear();
    for (var row in teste) {
      comandos
          .addEntries(<String, String>{row['comando']: row['acao']}.entries);
    }

    print(comandos.keys.toList());
    print(comandos);
  }
}
