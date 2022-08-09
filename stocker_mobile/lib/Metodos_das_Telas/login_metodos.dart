import '../DadosDB/CRUD.dart';

class Login {
  static int alteraloginID = 1;

  Future<bool> autorizaLogin(String usuario, String senha) async {
    var teste = CRUD();
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.selectUL();

    for (int i = 0; i < listaU.length; i = i + 5) {
      if (usuario == listaU[i + 1] && senha == listaU[i + 2]) {
        autoriza = Future<bool>.value(true);
      }
    }
    return autoriza;
  }

  Future<bool> novoLogin(String usuario, String senha) async {
    var teste = CRUD();
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.selectUL();

    for (int i = 0; i < listaU.length; i = i + 5) {
      if (usuario == listaU[i + 1] && senha == listaU[i + 2]) {
        if (listaU[i + 3] == 0) {
          autoriza = Future<bool>.value(true);
          alteraloginID = listaU[i];
        }
      }
    }
    return autoriza;
  }

  Future<bool> mudaSenha(String usuario, String senha) async {
    var teste = CRUD();
    Future<bool> autoriza = Future<bool>.value(false);
    var listaU = [];
    listaU = await teste.selectUL();

    for (int i = 0; i < listaU.length; i = i + 5) {
      if (usuario == listaU[i + 1] && senha == listaU[i + 2]) {
        if (listaU[i + 4] == 0) {
          autoriza = Future<bool>.value(true);
          alteraloginID = listaU[i];
        }
      }
    }
    return autoriza;
  }

  int getAlteraLoginID() {
    return alteraloginID;
  }
}
