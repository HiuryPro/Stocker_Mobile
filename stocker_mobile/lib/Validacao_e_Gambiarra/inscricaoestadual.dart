class InscE {
  bool valida(String inscricaoEstadual, String siglaUf) {
    String strIE = inscricaoEstadual;
    siglaUf = siglaUf.toUpperCase();
    if (siglaUf == "AC") {
      return validaIEAcre(strIE);
    } else {
      if (siglaUf == "AL") {
        return validaIEAlagoas(strIE);
      } else {
        if (siglaUf == "AP") {
          return validaIEAmapa(strIE);
        } else {
          if (siglaUf == "AM") {
            return validaIEAmazonas(strIE);
          } else {
            if (siglaUf == "BA") {
              return validaIEBahia(strIE);
            } else {
              if (siglaUf == "CE") {
                return validaIECeara(strIE);
              } else {
                if (siglaUf == "ES") {
                  return validaIEEspiritoSanto(strIE);
                } else {
                  if (siglaUf == "GO") {
                    return validaIEGoias(strIE);
                  } else {
                    if (siglaUf == "MA") {
                      return validaIEMaranhao(strIE);
                    } else {
                      if (siglaUf == "MT") {
                        return validaIEMatoGrosso(strIE);
                      } else {
                        if (siglaUf == "MS") {
                          return validaIEMatoGrossoSul(strIE);
                        } else {
                          if (siglaUf == "MG") {
                            return validaIEMinasGerais(strIE);
                          } else {
                            if (siglaUf == "PA") {
                              return validaIEPara(strIE);
                            } else {
                              if (siglaUf == "PB") {
                                return validaIEParaiba(strIE);
                              } else {
                                if (siglaUf == "PR") {
                                  return validaIEParana(strIE);
                                } else {
                                  if (siglaUf == "PE") {
                                    return validaIEPernambuco(strIE);
                                  } else {
                                    if (siglaUf == "PI") {
                                      return validaIEPiaui(strIE);
                                    } else {
                                      if (siglaUf == "RJ") {
                                        return validaIERioJaneiro(strIE);
                                      } else {
                                        if (siglaUf == "RN") {
                                          return validaIERioGrandeNorte(strIE);
                                        } else {
                                          if (siglaUf == "RS") {
                                            return validaIERioGrandeSul(strIE);
                                          } else {
                                            if (siglaUf == "RO") {
                                              return validaIERondonia(strIE);
                                            } else {
                                              if (siglaUf == "RR") {
                                                return validaIERoraima(strIE);
                                              } else {
                                                if (siglaUf == "SC") {
                                                  return validaIESantaCatarina(
                                                      strIE);
                                                } else {
                                                  if (siglaUf == "SP") {
                                                    if (inscricaoEstadual
                                                            .codeUnitAt(0) ==
                                                        'P'.codeUnitAt(0)) {
                                                      strIE = ("P" + strIE);
                                                    }
                                                    return validaIESaoPaulo(
                                                        strIE);
                                                  } else {
                                                    if (siglaUf == "SE") {
                                                      return validaIESergipe(
                                                          strIE);
                                                    } else {
                                                      if (siglaUf == "TO") {
                                                        return validaIETocantins(
                                                            strIE);
                                                      } else {
                                                        if (siglaUf == "DF") {
                                                          return validaIEDistritoFederal(
                                                              strIE);
                                                        } else {
                                                          return false;
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

  bool validaIEAcre(String ie) {
    if (ie.length != 13) {
      return false;
    } else {
      for (int i = 0; i < 2; i++) {
        if (int.parse(ie[i]) != i) {
          return false;
        }
      }
      int soma = 0;
      int pesoInicial = 4;
      int pesoFinal = 9;
      int d1 = 0;
      int d2 = 0;
      for (int i = 0; i < (ie.length - 2); i++) {
        if (i < 3) {
          soma += (int.parse(ie[i]) * pesoInicial);
          pesoInicial--;
        } else {
          soma += (int.parse(ie[i]) * pesoFinal);
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
          soma += (int.parse(ie[i]) * pesoInicial);
          pesoInicial--;
        } else {
          soma += (int.parse(ie[i]) * pesoFinal);
          pesoFinal--;
        }
      }
      d2 = (11 - (soma % 11));
      if ((d2 == 10) || (d2 == 11)) {
        d2 = 0;
      }
      String dv = (d1.toString() + d2.toString());
      if (!(dv == ie.substring(ie.length - 2, ie.length))) {
        return false;
      } else {
        return true;
      }
    }
  }

  bool validaIEAlagoas(String ie) {
    if (ie.length != 9) {
      return false;
    }
    if (!(ie.substring(0, 2) == "24")) {
      return false;
    }
    List<int> digits = [0, 3, 5, 7, 8];
    bool check = false;
    for (int i = 0; i < digits.length; i++) {
      if (int.parse(ie[2]) == digits[i]) {
        check = true;
        break;
      }
    }
    if (!check) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = 0;
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = ((soma * 10) % 11);
    if (d == 10) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEAmapa(String ie) {
    if (ie.length != 9) {
      return false;
    }
    if (!(ie.substring(0, 2) == "03")) {
      return false;
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
      soma += (int.parse(ie[i]) * peso);
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
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEAmazonas(String ie) {
    if (ie.length != 9) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
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
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEBahia(String ie) {
    if ((ie.length != 8) && (ie.length != 9)) {
      return false;
    }
    int modulo = 10;
    int firstDigit = int.parse(ie[(ie.length == 8) ? 0 : 1]);
    if (((firstDigit == 6) || (firstDigit == 7)) || (firstDigit == 9)) {
      modulo = 11;
    }
    int d2 = (-1);
    int soma = 0;
    int peso = ((ie.length == 8) ? 7 : 8);
    for (int i = 0; i < (ie.length - 2); i++) {
      soma += (int.parse(ie[i]) * peso);
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
      soma += (int.parse(ie[i]) * peso);
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
      return false;
    } else {
      return true;
    }
  }

  bool validaIECeara(String ie) {
    if (ie.length != 9) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 10) || (d == 11)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    }
    return true;
  }

  bool validaIEEspiritoSanto(String ie) {
    if (ie.length != 9) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
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
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    }
    return true;
  }

  bool validaIEGoias(String ie) {
    if (ie.length != 9) {
      return false;
    }
    if (!("10" == ie.substring(0, 2))) {
      if (!("11" == ie.substring(0, 2))) {
        if (!("15" == ie.substring(0, 2))) {
          return false;
        }
      }
    }
    if (ie.substring(0, ie.length - 1) == "11094402") {
      if (!(ie.substring(ie.length - 1, ie.length) == "0")) {
        if (!(ie.substring(ie.length - 1, ie.length) == "1")) {
          return false;
        }
      }
    } else {
      int soma = 0;
      int peso = 9;
      int d = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        soma += (int.parse(ie[i]) * peso);
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
      String dv = d.toString();
      if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
        return false;
      }
    }
    return true;
  }

  bool validaIEMaranhao(String ie) {
    if (ie.length != 9) {
      return false;
    }
    if (!(ie.substring(0, 2) == "12")) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    }
    return true;
  }

  bool validaIEMatoGrosso(String ie) {
    if (ie.length != 11) {
      return false;
    }
    int soma = 0;
    int pesoInicial = 3;
    int pesoFinal = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if (i < 2) {
        soma += (int.parse(ie[i]) * pesoInicial);
        pesoInicial--;
      } else {
        soma += (int.parse(ie[i]) * pesoFinal);
        pesoFinal--;
      }
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    }
    return true;
  }

  bool validaIEMatoGrossoSul(String ie) {
    if (ie.length != 9) {
      return false;
    }
    if (!(ie.substring(0, 2) == "28")) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
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
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEMinasGerais(String ie) {
    RegExp digitRegExp = RegExp(r'\d');
    bool isDigit(String s, int idx) => s[idx].contains(digitRegExp);

    if (ie.length != 13) {
      return false;
    }
    String str = "";
    for (int i = 0; i < (ie.length - 2); i++) {
      if (isDigit(ie, i)) {
        if (i == 3) {
          str += "0";
          str += ie[i];
        } else {
          str += ie[i];
        }
      }
    }
    int soma = 0;
    int pesoInicio = 1;
    int pesoFim = 2;
    int d1 = (-1);
    for (int i = 0; i < str.length; i++) {
      if ((i % 2) == 0) {
        int x = (int.parse(str[i]) * pesoInicio);
        String strX = x.toString();
        for (int j = 0; j < strX.length; j++) {
          soma += int.parse(strX[j]);
        }
      } else {
        int y = (int.parse(str[i]) * pesoFim);
        String strY = y.toString();
        for (int j = 0; j < strY.length; j++) {
          soma += int.parse(strY[j]);
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
        soma += (int.parse(ie[i]) * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse(ie[i]) * pesoFim);
        pesoFim--;
      }
    }
    d2 = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d2 = 0;
    }
    String dv = (d1.toString() + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEPara(String ie) {
    if (ie.length != 9) {
      return false;
    }
    if (!(ie.substring(0, 2) == "15")) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEParaiba(String ie) {
    if (ie.length != 9) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 10) || (d == 11)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEParana(String ie) {
    if (ie.length != 10) {
      return false;
    }
    int soma = 0;
    int pesoInicio = 3;
    int pesoFim = 7;
    int d1 = (-1);
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 2) {
        soma += (int.parse(ie[i]) * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse(ie[i]) * pesoFim);
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
        soma += (int.parse(ie[i]) * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse(ie[i]) * pesoFim);
        pesoFim--;
      }
    }
    d2 = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d2 = 0;
    }
    String dv = (d1.toString() + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIEPernambuco(String ie) {
    if (ie.length != 9) {
      return false;
    }

    int soma = 0;
    int pesoFim = 8;
    int d = (-1);
    int d2 = -1;

    for (int i = 0; i < (ie.length - 2); i++) {
      print(pesoFim);
      soma += (int.parse(ie[i]) * pesoFim);
      pesoFim--;
    }
    print(soma);

    if ((soma % 11) == 1 || (soma % 11) == 0) {
      d = 0;
    } else {
      d = 11 - (soma % 11);
      print(d);
    }

    if (int.parse(ie[8 - 1]) == d) {
      soma = 0;
      pesoFim = 9;
      for (int i = 0; i < (ie.length - 1); i++) {
        print(pesoFim);
        soma += (int.parse(ie[i]) * pesoFim);
        pesoFim--;
      }

      if ((soma % 11) == 1 || (soma % 11) == 0) {
        d2 = 0;
      } else {
        d2 = 11 - (soma % 11);
      }

      if (int.parse(ie[8]) == d2) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool validaIEPiaui(String ie) {
    if (ie.length != 9) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 11) || (d == 10)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIERioJaneiro(String ie) {
    if (ie.length != 8) {
      return false;
    }
    int soma = 0;
    int peso = 7;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if (i == 0) {
        soma += (int.parse(ie[i]) * 2);
      } else {
        soma += (int.parse(ie[i]) * peso);
        peso--;
      }
    }
    d = (11 - (soma % 11));
    if ((soma % 11) <= 1) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIERioGrandeNorte(String ie) {
    if ((ie.length != 10) && (ie.length != 9)) {
      return false;
    }
    if (!(ie.substring(0, 2) == "20")) {
      return false;
    }
    if (ie.length == 9) {
      int soma = 0;
      int peso = 9;
      int d = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        soma += (int.parse(ie[i]) * peso);
        peso--;
      }
      d = ((soma * 10) % 11);
      if (d == 10) {
        d = 0;
      }
      String dv = d.toString();
      if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
        return false;
      } else {
        return true;
      }
    } else {
      int soma = 0;
      int peso = 10;
      int d = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        soma += (int.parse(ie[i]) * peso);
        peso--;
      }
      d = ((soma * 10) % 11);
      if (d == 10) {
        d = 0;
      }
      String dv = d.toString();
      if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
        return false;
      } else {
        return true;
      }
    }
  }

  bool validaIERioGrandeSul(String ie) {
    if (ie.length != 10) {
      return false;
    }
    int soma = (int.parse(ie[0]) * 2);
    int peso = 9;
    int d = (-1);
    for (int i = 1; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((d == 10) || (d == 11)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIERondonia(String ie) {
    if (ie.length != 14) {
      return false;
    }
    int soma = 0;
    int pesoInicio = 6;
    int pesoFim = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      if (i < 5) {
        soma += (int.parse(ie[i]) * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse(ie[i]) * pesoFim);
        pesoFim--;
      }
    }
    d = (11 - (soma % 11));
    if ((d == 11) || (d == 10)) {
      d -= 10;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIERoraima(String ie) {
    if (ie.length != 9) {
      return false;
    }
    if (!(ie.substring(0, 2) == "24")) {
      return false;
    }
    int soma = 0;
    int peso = 1;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso++;
    }
    d = (soma % 9);
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIESantaCatarina(String ie) {
    if (ie.length != 9) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((soma % 11) == 0) || ((soma % 11) == 1)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIESaoPaulo(String ie) {
    if ((ie.length != 12) && (ie.length != 13)) {
      return false;
    }
    if (ie.length == 12) {
      int soma = 0;
      int peso = 1;
      int d1 = (-1);
      for (int i = 0; i < (ie.length - 4); i++) {
        if ((i == 1) || (i == 7)) {
          soma += (int.parse(ie[i]) * (++peso));
          peso++;
        } else {
          soma += (int.parse(ie[i]) * peso);
          peso++;
        }
      }
      d1 = (soma % 11);
      String strD1 = d1.toString();
      d1 = int.parse(strD1[strD1.length - 1]);
      soma = 0;
      int pesoInicio = 3;
      int pesoFim = 10;
      int d2 = (-1);
      for (int i = 0; i < (ie.length - 1); i++) {
        if (i < 2) {
          soma += (int.parse(ie[i]) * pesoInicio);
          pesoInicio--;
        } else {
          soma += (int.parse(ie[i]) * pesoFim);
          pesoFim--;
        }
      }
      d2 = (soma % 11);
      String strD2 = d2.toString();
      d2 = int.parse(strD2[strD2.length - 1]);
      if (!(ie.substring(8, 9) == d1.toString())) {
        return false;
      }
      if (!(ie.substring(11, 12) == d2.toString())) {
        return false;
      }
    } else {
      if (ie[0] != 'P') {
        return false;
      }
      String strIE = ie.substring(1, 10);
      int soma = 0;
      int peso = 1;
      int d1 = (-1);
      for (int i = 0; i < (strIE.length - 1); i++) {
        if ((i == 1) || (i == 7)) {
          soma += (int.parse(strIE[i]) * (++peso));
          peso++;
        } else {
          soma += (int.parse(strIE[i]) * peso);
          peso++;
        }
      }
      d1 = (soma % 11);
      String strD1 = d1.toString();
      d1 = int.parse(strD1[strD1.length - 1]);
      if (!(ie.substring(9, 10) == d1.toString())) {
        return false;
      }
    }
    return true;
  }

  bool validaIESergipe(String ie) {
    if (ie.length != 9) {
      return false;
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if (((d == 11) || (d == 11)) || (d == 10)) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    } else {
      return true;
    }
  }

  bool validaIETocantins(String ie) {
    if ((ie.length != 9) && (ie.length != 11)) {
      return false;
    } else {
      if (ie.length == 11) {
        ie = (ie.substring(0, 2) + ie.substring(4));
      }
    }
    int soma = 0;
    int peso = 9;
    int d = (-1);
    for (int i = 0; i < (ie.length - 1); i++) {
      soma += (int.parse(ie[i]) * peso);
      peso--;
    }
    d = (11 - (soma % 11));
    if ((soma % 11) < 2) {
      d = 0;
    }
    String dv = d.toString();
    if (!(ie.substring(ie.length - 1, ie.length) == dv)) {
      return false;
    }
    return true;
  }

  bool validaIEDistritoFederal(String ie) {
    if (ie.length != 13) {
      return false;
    }
    int soma = 0;
    int pesoInicio = 4;
    int pesoFim = 9;
    int d1 = (-1);
    for (int i = 0; i < (ie.length - 2); i++) {
      if (i < 3) {
        soma += (int.parse(ie[i]) * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse(ie[i]) * pesoFim);
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
        soma += (int.parse(ie[i]) * pesoInicio);
        pesoInicio--;
      } else {
        soma += (int.parse(ie[i]) * pesoFim);
        pesoFim--;
      }
    }
    d2 = (11 - (soma % 11));
    if ((d2 == 11) || (d2 == 10)) {
      d2 = 0;
    }
    String dv = (d1.toString() + d2.toString());
    if (!(dv == ie.substring(ie.length - 2, ie.length))) {
      return false;
    } else {
      return true;
    }
  }
}
