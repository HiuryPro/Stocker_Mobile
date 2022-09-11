import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskaraInscE {
  MaskTextInputFormatter maskara(String mask) {
    return MaskTextInputFormatter(
        mask: mask,
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  MaskTextInputFormatter estadoMascara(String uf) {
    if (uf == "MG") {
      return maskara("###.###.###/####");
    } else if (uf == "GO") {
      return maskara("##.###.###-#");
    } else {
      return maskara("#");
    }
  }
}
