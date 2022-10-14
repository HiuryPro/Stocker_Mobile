import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MaskaraInscE {
  MaskTextInputFormatter maskara(String mask) {
    return MaskTextInputFormatter(
        mask: mask,
        filter: {"#": RegExp(r'[0-9]')},
        type: MaskAutoCompletionType.lazy);
  }

  MaskTextInputFormatter estadoMascara({required String uf, int escolha = 0}) {
    if (uf == "AC") {
      return maskara("##.###.###/###-##");
    } else if (uf == "AL" || uf == "AP") {
      return maskara("#########");
    } else if (uf == "AM" || uf == "GO" || uf == "RN") {
      return maskara("##.###.###-#");
    } else if (uf == "PE") {
      return maskara("#######-##");
    } else if (uf == "CE" ||
        uf == "ES" ||
        uf == "MA" ||
        uf == "MS" ||
        uf == "PB" ||
        uf == "PI" ||
        uf == "RR" ||
        uf == "SE") {
      return maskara("########-#");
    } else if (uf == "DF") {
      return maskara("###########-##");
    } else if (uf == "MG") {
      return maskara("###.###.###/####");
    } else if (uf == "MT") {
      return maskara("##########-#");
    } else if (uf == "PA") {
      return maskara("##-######-#");
    } else if (uf == "PR") {
      return maskara("###.#####-##");
    } else if (uf == "RJ") {
      return maskara("##.###.##-#");
    } else if (uf == "RO") {
      return maskara("#############-#");
    } else if (uf == "RS") {
      return maskara("###/#######");
    } else if (uf == "SC") {
      return maskara("###.###.###");
    } else if (uf == "SP") {
      return maskara("###.###.###.###");
    } else {
      return maskara("#");
    }
  }
}
