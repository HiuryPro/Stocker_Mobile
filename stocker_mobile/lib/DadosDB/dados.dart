import 'package:stocker_mobile/DadosDB/db.dart';

class Dados extends Conexao {
  pegaUsuario() async {
    var results = await usuario();
    var usuarios = [];

    for (var row in results) {
      usuarios.add(row['id']);
      usuarios.add(row['login']);
      usuarios.add(row['senha']);
      usuarios.add(row['confirma_login']);
    }

    return usuarios;
  }

  pegaUsuarioDadosV() async {
    var results = await usuarioDados();
    var dados = [];

    for (var row in results) {
      dados.add(row['nome_empresa']);
      dados.add(row['cnpj']);
      dados.add(row['email']);
      dados.add(row['telefone']);
      dados.add(row['endereco']);
    }
    return dados;
  }
}
