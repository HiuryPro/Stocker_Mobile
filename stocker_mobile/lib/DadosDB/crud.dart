import 'package:http/http.dart' as http;
import 'dart:convert';

class CRUD {
  insertUD(List<String> lista) async {
    var url = Uri.parse("http://192.168.3.9/ConexaoDBStocker/cadastro.php");
    await http.post(url, body: {
      "nome_empresa": lista[0],
      "cnpj": lista[1],
      "email": lista[2],
      "endereco": lista[3],
      "cidade": lista[4],
      "estado": lista[5],
      "telefone": lista[6],
      "ganho_mensal": lista[7],
    });
  }

  inserUL(String login, String senha) async {
    var url =
        Uri.parse("http://192.168.3.9/ConexaoDBStocker/cadastro_login.php");
    await http.post(url, body: {
      "login": login,
      "senha": senha,
    });
  }

  updateUL(String login, String senha, int id) async {
    var url =
        Uri.parse("http://192.168.3.9/ConexaoDBStocker/atualiza_login.php");
    await http.post(url, body: {"login": login, "senha": senha, "id": "$id"});
  }

  updateSenha(int id, String random, int ns) async {
    var url =
        Uri.parse("http://192.168.3.9/ConexaoDBStocker/atualiza_senha.php");
    await http.post(url, body: {"senha": random, "ns": "$ns", "id": "$id"});
  }

  selectUL() async {
    dynamic body;
    var url = Uri.parse("http://192.168.3.9/ConexaoDBStocker/login.php");
    http.Response response = await http.get(url);
    body = jsonDecode(response.body);
    var usuarios = [];

    for (var row in body) {
      usuarios.add(row['id']);
      usuarios.add(row['login']);
      usuarios.add(row['senha']);
      usuarios.add(row['confirma_login']);
      usuarios.add(row['nova_senha']);
    }

    return usuarios;
  }

  selectUD() async {
    dynamic body;
    var url =
        Uri.parse("http://192.168.3.9/ConexaoDBStocker/usuario_dados.php");
    http.Response response = await http.get(url);
    body = jsonDecode(response.body);

    var dados = [];

    for (var row in body) {
      dados.add(row['id']);
      dados.add(row['nome_empresa']);
      dados.add(row['cnpj']);
      dados.add(row['email']);
      dados.add(row['cidade']);
      dados.add(row['estado']);
      dados.add(row['endereco']);
      dados.add(row['telefone']);
      dados.add(row['ganho_mensal']);
    }
    return dados;
  }
}
