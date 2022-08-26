import '../DadosDB/CRUD.dart';

class Login {
  static int alteraloginID = 1;

  Future<bool> autorizaLogin(String usuario, String senha) async {
    var teste = CRUD();
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.select("SELECT *  FROM usuario_login ");

    for (var row in listaU) {
      if (usuario == row['login'] && senha == row['senha']) {
        autoriza = Future<bool>.value(true);
        break;
      }
    }

    return autoriza;
  }

  Future<bool> novoLogin(String usuario, String senha) async {
    var teste = CRUD();
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.select("SELECT *  FROM usuario_login ");

    for (var row in listaU) {
      if (usuario == row['login'] && senha == row['senha']) {
        if (row['confirma_login'] == 0) {
          autoriza = Future<bool>.value(true);
          alteraloginID = row['id'];
          break;
        }
      }
    }

    return autoriza;
  }

  Future<bool> mudaSenha(String usuario, String senha) async {
    var teste = CRUD();
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.select("SELECT *  FROM usuario_login ");

    for (var row in listaU) {
      if (usuario == row['login'] && senha == row['senha']) {
        if (row['nova_senha'] == 0) {
          autoriza = Future<bool>.value(true);
          alteraloginID = row['id'];
          break;
        }
      }
    }

    return autoriza;
  }

  int getAlteraLoginID() {
    return alteraloginID;
  }
}
