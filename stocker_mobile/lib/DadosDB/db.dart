import 'package:http/http.dart' as http;
import 'dart:convert';

class Conexao {
  // ignore: prefer_typing_uninitialized_variables
  Future usuario() async {
    dynamic body;
    var url = Uri.parse("http://192.168.3.9/ConexaoDBStocker/login.php");
    http.Response response = await http.get(url);
    body = jsonDecode(response.body);
    return body;
  }

  cadUsuario(List<String> lista) async {
    var url = Uri.parse("http://192.168.3.9/ConexaoDBStocker/cadastro.php");
    await http.post(url, body: {
      "nome_empresa": lista[0],
      "cnpj": lista[1],
      "email": lista[2],
      "endereco": lista[3],
      "cidade": lista[4],
      "estado": lista[5],
      "ganho_mensal": lista[6],
      "telefone": lista[7]
    });
  }
}

class Dados {
  var teste = Conexao();

  pegaUsuario() async {
    var results = await teste.usuario();
    var usuario = [];

    for (var row in results) {
      usuario.add(row['login']);
    }

    return usuario;
  }

  pegaSenha() async {
    var results = await teste.usuario();
    var senha = [];
    for (var row in results) {
      senha.add(row['senha']);
    }
    return senha;
  }
}
