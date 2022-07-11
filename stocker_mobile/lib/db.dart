import 'package:http/http.dart' as http;
import 'dart:convert';

class UserService {
  // ignore: prefer_typing_uninitialized_variables
  var results;
  Future register() async {
    dynamic body;
    var url = Uri.parse("http://192.168.3.9/ConexaoDBStocker/login.php");
    http.Response response = await http.get(url);
    body = jsonDecode(response.body);
    return body;
  }
}

/*
void main() async {
  var teste = UserService();
  var results = await teste.register();
  var id = [];
  var produto = [];
  var cliente = [];

  for (var row in results) {
    id.add(row['id']);
    produto.add(row['nome_produto']);
    cliente.add(row['cliente']);
  }

  for (int i = 0; i < id.length; i++) {
    print(id[i]);
    print(produto[i]);
    print(cliente[i]);
  }
}
*/

class Dados {
  var teste = UserService();

 

  pegaUsuario() async {
    var results = await teste.register();
    var usuario = [];
   

    for (var row in results) {
      usuario.add(row['login']);
    }

    return usuario;
  }

  pegaSenha() async {
    var results = await teste.register();
    var senha = [];
    for (var row in results) {
          senha.add(row['senha']);
        }
    return senha;
  }
}
