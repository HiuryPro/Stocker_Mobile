class InscE {
  static String removeMascara(String ie) {
    String strIE = "";
    for (int i = 0; i < ie.length; i++) {
      if (!ie.codeUnitAt(i).isNaN) {
        strIE += ie.codeUnitAt(i).toString();
      }
    }
    return strIE;
  }

  static void valida(String inscricaoEstadual, String siglaUf) {
    String strIE = removeMascara(inscricaoEstadual);
    siglaUf = siglaUf.toUpperCase();
    if (siglaUf == "AC") {
      validaIEAcre(strIE);
    } else {
      if (siglaUf == "AL") {
        validaIEAlagoas(strIE);
      } else {
        if (siglaUf == "AP") {
          validaIEAmapa(strIE);
        } else {
          if (siglaUf == "AM") {
            validaIEAmazonas(strIE);
          } else {
            if (siglaUf == "BA") {
              validaIEBahia(strIE);
            } else {
              if (siglaUf == "CE") {
                validaIECeara(strIE);
              } else {
                if (siglaUf == "ES") {
                  validaIEEspiritoSanto(strIE);
                } else {
                  if (siglaUf == "GO") {
                    validaIEGoias(strIE);
                  } else {
                    if (siglaUf == "MA") {
                      validaIEMaranhao(strIE);
                    } else {
                      if (siglaUf == "MT") {
                        validaIEMatoGrosso(strIE);
                      } else {
                        if (siglaUf == "MS") {
                          validaIEMatoGrossoSul(strIE);
                        } else {
                          if (siglaUf == "MG") {
                            validaIEMinasGerais(strIE);
                          } else {
                            if (siglaUf == "PA") {
                              validaIEPara(strIE);
                            } else {
                              if (siglaUf == "PB") {
                                validaIEParaiba(strIE);
                              } else {
                                if (siglaUf == "PR") {
                                  validaIEParana(strIE);
                                } else {
                                  if (siglaUf == "PE") {
                                    validaIEPernambuco(strIE);
                                  } else {
                                    if (siglaUf == "PI") {
                                      validaIEPiaui(strIE);
                                    } else {
                                      if (siglaUf == "RJ") {
                                        validaIERioJaneiro(strIE);
                                      } else {
                                        if (siglaUf == "RN") {
                                          validaIERioGrandeNorte(strIE);
                                        } else {
                                          if (siglaUf == "RS") {
                                            validaIERioGrandeSul(strIE);
                                          } else {
                                            if (siglaUf == "RO") {
                                              validaIERondonia(strIE);
                                            } else {
                                              if (siglaUf == "RR") {
                                                validaIERoraima(strIE);
                                              } else {
                                                if (siglaUf == "SC") {
                                                  validaIESantaCatarina(strIE);
                                                } else {
                                                  if (siglaUf == "SP") {
                                                    if (inscricaoEstadual
                                                            .codeUnitAt(0) ==
                                                        'P'.codeUnitAt(0)) {
                                                      strIE = ("P$strIE");
                                                    }
                                                    validaIESaoPaulo(strIE);
                                                  } else {
                                                    if (siglaUf == "SE") {
                                                      validaIESergipe(strIE);
                                                    } else {
                                                      if (siglaUf == "TO") {
                                                        validaIETocantins(
                                                            strIE);
                                                      } else {
                                                        if (siglaUf == "DF") {
                                                          validaIEDistritoFederal(
                                                              strIE);
                                                        } else {
                                                          throw Exception(
                                                              "Estado não encontrado : $siglaUf");
                                                        }
                                                      }
                                                    }
                                                  }
                                                }
                                              }
                                            }
                                          }
                                        }
                                      }
                                    }
                                  }
                                }
                              }
                            }
                          }
                        }
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  static void validaIEAcre(String ie) {
    if (ie.length != 13) {
      throw Exception("Quantidade de digitos inválida.");
    }
    for (int i = 0; i < 2; i++) {
      if (int.parse("${ie.codeUnitAt(i)}") != i) {
        throw Exception("Inscrição Estadual inválida");
      }
    }
    int soma = 0;
    int pesoInicial = 4;
    int pesoFinal = 9;
    int d1 = 0;
    int d2 = 0;
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 3) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicial);
        pesoInicial--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFinal);
        pesoFinal--;
      }
    }
    d1 = (11 - (soma % 11));
    if ((d1 == 10) || (d1 == 11)) {
      d1 = 0;
    }
    soma = (d1 * 2);
    pesoInicial = 5;
    pesoFinal = 9;
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 4) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicial);
        pesoInicial--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFinal);
        pesoFinal--;
      }
    }
    d2 = (11 - (soma % 11));
    if ((d2 == 10) || (d2 == 11)) {
      d2 = 0;
    }
    String dv = (("$d1") + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEAlagoas(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de d&#65533;gitos inv&#65533;lida.");
    }
    if (!(ie.substring(0, 2) == "24")) {
      throw Exception("Inscrição estadual inválida.");
    }
    List<int> digits = [0, 3, 5, 7, 8];
    bool check = false;
    for (int i = 0; i < digits.length; i++) {
      if (int.parse("${ie.codeUnitAt(2)}") == digits[i]) {
        check = true;
        break;
      }
    }
    if (!check) {
      throw Exception("Inscrição estadual inválida.");
    }
    int soma = 0;
    int peso = 9;
    int d = 0;
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = ((soma * 10) % 11);
    if (d == 10) {
      d = 0;
    }
    String dv = ("$d");
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEAmapa(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (!(ie.substring(0, 2) == "03")) {
      throw Exception("Inscrição estadual inválida.");
    }
    int d1 = (-1);
    int soma = (-1);
    int peso = 9;
    int x = int.parse(ie.substring(0, ie.length - 1));
    if ((x >= 3017001) && (x <= 3019022)) {
      d1 = 1;
      soma = 9;
    } else {
      if ((x >= 3000001) && (x <= 3017000)) {
        d1 = 0;
        soma = 5;
      } else {
        if (x >= 3019023) {
          d1 = 0;
          soma = 0;
        }
      }
    }
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    int d = (11 - (soma % 11));
    if (d == 10) {
      d = 0;
    } else {
      if (d == 11) {
        d = d1;
      }
    }
    String dv = ("$d");
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEAmazonas(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    if (soma < 11) {
      d = (11 - soma);
    } else {
      if ((soma % 11) <= 1) {
        d = 0;
      } else {
        d = (11 - (soma % 11));
      }
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEBahia(String ie) {
    if ((ie.length != 8) && (ie.length != 9)) {
      throw Exception("Quantidade de digitos inválidas.$ie");
    }
    int modulo = 10;
    int firstDigit = int.parse("${ie.codeUnitAt((ie.length == 8) ? 0 : 1)}");
    if (((firstDigit == 6) || (firstDigit == 7)) || (firstDigit == 9)) {
      modulo = 11;
    }
    int d2 = (-1);
    int soma = 0;
    int peso = ((ie.length == 8) ? 7 : 8);
    for (int i = 0; i < (ie.length - 2); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    int resto = (soma % modulo);
    if ((resto == 0) || ((modulo == 11) && (resto == 1))) {
      d2 = 0;
    } else {
      d2 = (modulo - resto);
    }
    int d1 = (-1);
    soma = (d2 * 2);
    peso = ((ie.length == 8) ? 8 : 9);
    for (int i = 0; i < (ie.length - 2); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    resto = (soma % modulo);
    if ((resto == 0) || ((modulo == 11) && (resto == 1))) {
      d1 = 0;
    } else {
      d1 = (modulo - resto);
    }
    String dv = (d1.toString() + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      throw Exception("Digito verificador inválido.$ie");
    }
  }

  static void validaIECeara(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 10) || (d == 11)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEEspiritoSanto(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    int resto = (soma % 11);
    if (resto < 2) {
      d = 0;
    } else {
      if (resto > 1) {
        d = (11 - resto);
      }
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEGoias(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (!("10" == ie.substring(0, 2))) {
      if (!("11" == ie.substring(0, 2))) {
        if (!("15" == ie.substring(0, 2))) {
          throw Exception("Inscrição estadual inválida");
        }
      }
    }
    if (ie.substring(0, ie.length - 1) == "11094402") {
      if (!(ie.substring(ie.length - 1, ie.length) == "0")) {
        if (!(ie.substring(ie.length - 1, ie.length) == "1")) {
          throw Exception("Inscrição estadual inválida.");
        }
      }
    } else {
      int soma = 0;
      int peso = 9;
      int d = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
        peso--;
      }
      int resto = (soma % 11);
      int faixaInicio = 10103105;
      int faixaFim = 10119997;
      int insc = int.parse(ie.substring(0, ie.length - 1));
      if (resto == 0) {
        d = 0;
      } else {
        if (resto == 1) {
          if ((insc >= faixaInicio) && (insc <= faixaFim)) {
            d = 1;
          } else {
            d = 0;
          }
        } else {
          if ((resto != 0) && (resto != 1)) {
            d = (11 - resto);
          }
        }
      }
      String dv = (d.toString());
      if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
        throw Exception("Digito verificador inválido.");
      }
    }
  }

  static void validaIEMaranhao(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (!(ie.substring(0, 2) == "12")) {
      throw Exception("Inscrição estadual inválida.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEMatoGrosso(String ie) {
    if (ie.length != 11) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int pesoInicial = 3;
    int pesoFinal = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if (i < 2) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicial);
        pesoInicial--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFinal);
        pesoFinal--;
      }
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEMatoGrossoSul(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (!(ie.substring(0, 2) == "28")) {
      throw Exception("Inscrição estadual inválida.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    int resto = (soma % 11);
    int result = (11 - resto);
    if (resto == 0) {
      d = 0;
    } else {
      if (resto > 0) {
        if (result > 9) {
          d = 0;
        } else {
          if (result < 10) {
            d = result;
          }
        }
      }
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEMinasGerais(String ie) {
    if (ie.length != 13) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    String str = "";
    for (int i = 0; i < (ie.length - 2); i++) {
      if (!ie.codeUnitAt(i).isNaN) {
        if (i == 3) {
          str += "0";
          str += ie.codeUnitAt(i).toString();
        } else {
          str += ie.codeUnitAt(i).toString();
        }
      }
    }
    int soma = 0;
    int pesoInicio = 1;
    int pesoFim = 2;
    int d1 = (-1);
    for (int i = 0; i < str.length; i++) {
      if ((i % 2) == 0) {
        int x = (int.parse("${str.codeUnitAt(i)}") * pesoInicio);
        String strX = x.toString();
        for (int j = 0; j < strX.length; j++) {
          soma += int.parse("${strX.codeUnitAt(j)}");
        }
      } else {
        int y = (int.parse("${str.codeUnitAt(i)}") * pesoFim);
        String strY = y.toString();
        for (int j = 0; j < strY.length; j++) {
          soma += int.parse("${strY.codeUnitAt(j)}");
        }
      }
    }
    int dezenaExata = soma;
    while ((dezenaExata % 10) != 0) {
      dezenaExata++;
    }
    d1 = (dezenaExata - soma);
    soma = (d1 * 2);
    pesoInicio = 3;
    pesoFim = 11;
    int d2 = (-1);
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 2) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
        pesoFim--;
      }
    }
    d2 = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d2 = 0;
    }
    String dv = (d1.toString() + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEPara(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (!(ie.substring(0, 2) == "15")) {
      throw Exception("Inscrição estadual inválida.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEParaiba(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 10) || (d == 11)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEParana(String ie) {
    if (ie.length != 10) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int pesoInicio = 3;
    int pesoFim = 7;
    int d1 = (-1);
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 2) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
        pesoFim--;
      }
    }
    d1 = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d1 = 0;
    }
    soma = (d1 * 2);
    pesoInicio = 4;
    pesoFim = 7;
    int d2 = (-1);
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 3) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
        pesoFim--;
      }
    }
    d2 = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d2 = 0;
    }
    String dv = (d1.toString() + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEPernambuco(String ie) {
    if (ie.length != 14) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int pesoInicio = 5;
    int pesoFim = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if (i < 5) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
        pesoFim--;
      }
    }
    d = (11 - (soma % 11));
    if (d > 9) {
      d -= 10;
    }
    print(soma);
    print(11 - (soma % 11));
    print(d);
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEPiaui(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 11) || (d == 10)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIERioJaneiro(String ie) {
    if (ie.length != 8) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 7;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if (i == 0) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * 2);
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
        peso--;
      }
    }
    d = (11 - (soma % 11));
    if ((soma % 11) <= 1) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIERioGrandeNorte(String ie) {
    if ((ie.length != 10) && (ie.length != 9)) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (!(ie.substring(0, 2) == "20")) {
      throw Exception("Inscrição estadual inválida.");
    }
    if (ie.length == 9) {
      int soma = 0;
      int peso = 9;
      int d = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
        peso--;
      }
      d = ((soma * 10) % 11);
      if (d == 10) {
        d = 0;
      }
      String dv = (d.toString());
      if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
        throw Exception("Digito verificador inválido.");
      }
    } else {
      int soma = 0;
      int peso = 10;
      int d = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
        peso--;
      }
      d = ((soma * 10) % 11);
      if (d == 10) {
        d = 0;
      }
      String dv = (d.toString());
      if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
        throw Exception("Digito verificador inválido.");
      }
    }
  }

  static void validaIERioGrandeSul(String ie) {
    if (ie.length != 10) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = (int.parse("${ie.codeUnitAt(0)}") * 2);
    int peso = 9;
    int d = (-1);
    for (int i = 1; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 10) || (d == 11)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIERondonia(String ie) {
    if (ie.length != 14) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int pesoInicio = 6;
    int pesoFim = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if (i < 5) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
        pesoFim--;
      }
    }
    d = (11 - (soma % 11));
    if ((d == 11) || (d == 10)) {
      d -= 10;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIERoraima(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (!(ie.substring(0, 2) == "24")) {
      throw Exception("Inscrição estadual inválida.");
    }
    int soma = 0;
    int peso = 1;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso++;
    }
    d = (soma % 9);
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIESantaCatarina(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIESaoPaulo(String ie) {
    if ((ie.length != 12) && (ie.length != 13)) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    if (ie.length == 12) {
      int soma = 0;
      int peso = 1;
      int d1 = (-1);
      for (int i = 0; i < (ie.length - 4); i++) {
        if ((i == 1) || (i == 7)) {
          soma += (int.parse("${ie.codeUnitAt(i)}") * (++peso));
          peso++;
        } else {
          soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
          peso++;
        }
      }
      d1 = (soma % 11);
      String strD1 = d1.toString();
      d1 = int.parse("${strD1.codeUnitAt(strD1.length - 1)}");
      soma = 0;
      int pesoInicio = 3;
      int pesoFim = 10;
      int d2 = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        if (i < 2) {
          soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
          pesoInicio--;
        } else {
          soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
          pesoFim--;
        }
      }
      d2 = (soma % 11);
      String strD2 = d2.toString();
      d2 = int.parse("${strD2.codeUnitAt(strD2.length - 1)}");
      if (!(ie.substring(8, 9) == (d1.toString()))) {
        throw Exception("Inscrição estadual inválida.");
      }
      if (!(ie.substring(11, 12) == (d2.toString()))) {
        throw Exception("Inscrição estadual inválida.");
      }
    } else {
      if (ie.codeUnitAt(0) != 'P'.codeUnitAt(0)) {
        throw Exception("Inscrição estadual inválida.");
      }
      String strIE = ie.substring(1, 10);
      int soma = 0;
      int peso = 1;
      int d1 = (-1);
      for (int i = 0; i < (strIE.length - 1); i++) {
        if ((i == 1) || (i == 7)) {
          soma += (int.parse("${strIE.codeUnitAt(i)}") * (++peso));
          peso++;
        } else {
          soma += (int.parse("${strIE.codeUnitAt(i)}") * peso);
          peso++;
        }
      }
      d1 = (soma % 11);
      String strD1 = d1.toString();
      d1 = int.parse("${strD1.codeUnitAt(strD1.length - 1)}");
      if (!(ie.substring(9, 10) == (d1.toString()))) {
        throw Exception("Inscrição estadual inválida.");
      }
    }
  }

  static void validaIESergipe(String ie) {
    if (ie.length != 9) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((d == 11) || (d == 11)) || (d == 10)) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIETocantins(String ie) {
    if ((ie.length != 9) && (ie.length != 11)) {
      throw Exception("Quantidade de d&#65533;gitos inv&#65533;lida.");
    } else {
      if (ie.length == 9) {
        ie = (("${ie.substring(0, 2)}02") + ie.substring(2));
      }
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if ((i != 2) && (i != 3)) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * peso);
        peso--;
      }
    }
    d = (11 - (soma % 11));
    if ((soma % 11) < 2) {
      d = 0;
    }
    String dv = (d.toString());
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      throw Exception("Digito verificador inválido.");
    }
  }

  static void validaIEDistritoFederal(String ie) {
    if (ie.length != 13) {
      throw Exception("Quantidade de digitos inválidas.");
    }
    int soma = 0;
    int pesoInicio = 4;
    int pesoFim = 9;
    int d1 = (-1);
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 3) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
        pesoFim--;
      }
    }
    d1 = (11 - (soma % 11));
    if ((d1 == 11) || (d1 == 10)) {
      d1 = 0;
    }
    soma = (d1 * 2);
    pesoInicio = 5;
    pesoFim = 9;
    int d2 = (-1);
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 4) {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse("${ie.codeUnitAt(i)}") * pesoFim);
        pesoFim--;
      }
    }
    d2 = (11 - (soma % 11));
    if ((d2 == 11) || (d2 == 10)) {
      d2 = 0;
    }
    String dv = ((d1.toString()) + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      throw Exception("Digito verificador inválido.");
    }
  }
}
