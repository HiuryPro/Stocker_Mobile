import 'package:stocker_mobile/DadosDB/db.dart';

class Dados extends Conexao {
  pegaUsuario() async {
    var results = await usuario();
    var usuarios = [];

    for (var row in results) {
      usuarios.add(row['login']);
    }

    return usuarios;
  }

  pegaSenha() async {
    var results = await usuario();
    var senha = [];
    for (var row in results) {
      senha.add(row['senha']);
    }
    return senha;
  }
}
