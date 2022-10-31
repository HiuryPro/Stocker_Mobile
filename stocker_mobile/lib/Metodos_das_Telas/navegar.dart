import 'package:flutter/material.dart';

class Navegar {
  static Navegar instance = Navegar();
  navegarEntreTela(String rota, var context, bool ativo) {
    return Navigator.of(context)
        .pushNamedAndRemoveUntil(rota, (Route<dynamic> route) => ativo);
  }

  /*  Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    CadPage2(response: resposta)),
                            (Route<dynamic> route) => false);*/
}
