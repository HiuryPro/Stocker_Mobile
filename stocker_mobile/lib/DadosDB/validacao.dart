import 'dados.dart';

class Validacao {
  var dados = Dados();
  String mensagem = '';

  bool validacnpj(String cnpj) {
    if (((((((((((cnpj == "00000000000000") || (cnpj == "11111111111111")) ||
                                        (cnpj == "22222222222222")) ||
                                    (cnpj == "33333333333333")) ||
                                (cnpj == "44444444444444")) ||
                            (cnpj == "55555555555555")) ||
                        (cnpj == "66666666666666")) ||
                    (cnpj == "77777777777777")) ||
                (cnpj == "88888888888888")) ||
            (cnpj == "99999999999999")) ||
        (cnpj.length != 14)) {
      return false;
    }
    int dig13;
    int dig14;
    int sm;
    int i;
    int r;
    int num;
    int peso;
    try {
      sm = 0;
      peso = 2;
      for ((i = 11); i >= 0; i--) {
        num = (cnpj.codeUnitAt(i) - 48);
        sm = (sm + (num * peso));
        peso = (peso + 1);
        if (peso == 10) {
          peso = 2;
        }
      }
      r = (sm % 11);
      if ((r == 0) || (r == 1)) {
        dig13 = '0'.codeUnitAt(0);
      } else {
        dig13 = ((11 - r) + 48);
      }
      sm = 0;
      peso = 2;
      for ((i = 12); i >= 0; i--) {
        num = (cnpj.codeUnitAt(i) - 48);
        sm = (sm + (num * peso));
        peso = (peso + 1);
        if (peso == 10) {
          peso = 2;
        }
      }
      r = (sm % 11);
      if ((r == 0) || (r == 1)) {
        dig14 = '0'.codeUnitAt(0);
      } else {
        dig14 = ((11 - r) + 48);
      }
      if ((dig13 == cnpj.codeUnitAt(12)) && (dig14 == cnpj.codeUnitAt(13))) {
        return true;
      }

      return false;
      // ignore: non_constant_identifier_names
    } catch (InputMismatchException) {
      return false;
    }
  }

  bool iscpf(String cpf) {
    if (((((((((((cpf == "00000000000") || (cpf == "11111111111")) ||
                                        (cpf == "22222222222")) ||
                                    (cpf == "33333333333")) ||
                                (cpf == "44444444444")) ||
                            (cpf == "55555555555")) ||
                        (cpf == "66666666666")) ||
                    (cpf == "77777777777")) ||
                (cpf == "88888888888")) ||
            (cpf == "99999999999")) ||
        (cpf.length != 11)) {
      return false;
    }
    int dig10;
    int dig11;
    int sm;
    int i;
    int r;
    int num;
    int peso;
    try {
      sm = 0;
      peso = 10;
      for ((i = 0); i < 9; i++) {
        num = (cpf.codeUnitAt(i) - 48);
        sm = (sm + (num * peso));
        peso = (peso - 1);
      }
      r = (11 - (sm % 11));
      if ((r == 10) || (r == 11)) {
        dig10 = '0'.codeUnitAt(0);
      } else {
        dig10 = (r + 48);
      }
      sm = 0;
      peso = 11;
      for ((i = 0); i < 10; i++) {
        num = (cpf.codeUnitAt(i) - 48);
        sm = (sm + (num * peso));
        peso = (peso - 1);
      }
      r = (11 - (sm % 11));
      if ((r == 10) || (r == 11)) {
        dig11 = '0'.codeUnitAt(0);
      } else {
        dig11 = (r + 48);
      }
      if ((dig10 == cpf.codeUnitAt(9)) && (dig11 == cpf.codeUnitAt(10))) {
        return true;
      } else {
        return false;
      }
      // ignore: non_constant_identifier_names
    } catch (InputMismatchException) {
      return false;
    }
  }

  Future<bool> validaCad(String nomeE, String cnpj, String email,
      String telefone, String endereco) async {
    Future<bool> valida = Future<bool>.value(true);
    var itens = await dados.pegaUsuarioDadosV();

    if (itens[0] == nomeE) {
      valida = Future<bool>.value(false);
      mensagem = 'Esse nome de empresa já está em uso';
    } else if (itens[1] == cnpj) {
      valida = Future<bool>.value(false);
      mensagem = 'Esse cnpj já está em uso';
    } else if (itens[2] == email) {
      valida = Future<bool>.value(false);
      mensagem = 'Esse email já está em uso';
    } else if (itens[3] == telefone) {
      valida = Future<bool>.value(false);
      mensagem = 'Esse telefone já está em uso';
    } else if (itens[4] == endereco) {
      valida = Future<bool>.value(false);
      mensagem = 'Esse endereço já está em uso';
    }

    return valida;
  }

  Future<bool> isVazio(List<String> lista) async {
    Map<String, String> usuario = {
      '0': "Nome da Empresa",
      '1': "CNPJ",
      '2': "Email",
      '3': "Endereço",
      '4': "Cidade",
      '5': "Estado",
      '6': "Telefone",
      '7': "Ganho Mensal"
    };
    Future<bool> valida = Future<bool>.value(true);
    for (int i = 0; i < lista.length; i++) {
      if (lista[i].isEmpty) {
        mensagem = 'Campo ${usuario['$i']} está vazio';
        valida = Future<bool>.value(false);
        break;
      }
    }
    return valida;
  }

  String getMensagem() {
    return mensagem;
  }

  String abrevia(String nome) {
    String nomeA;
    nomeA = "";
    int i;

    for ((i = 0); i < nome.length; i++) {
      if (i == 0) {
        nomeA = (nomeA + nome[i]);
      }
      if (nome[i].compareTo(' ') == 0) {
        nomeA = (nomeA + nome[i + 1]);
      }
    }
    print(nomeA);

    return nomeA;
  }
}
