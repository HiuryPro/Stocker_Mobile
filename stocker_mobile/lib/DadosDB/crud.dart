import 'package:http/http.dart' as http;
import 'dart:convert';

class CRUD {
  final String ip = "192.168.3.9";

  select(String query) async {
    dynamic body;
    var url = Uri.parse("http://$ip/ConexaoDBStocker/Select.php");
    http.Response response = await http.post(url, body: {'query': query});
    body = jsonDecode(response.body);

    return body;
  }

  insert(String query, List<String> lista) async {
    var url = Uri.parse("http://$ip/ConexaoDBStocker/Insert.php");
    await http.post(url, body: {'query': query, 'lista': jsonEncode(lista)});
  }

  updateUL(String login, String senha, int id) async {
    var url = Uri.parse("http://$ip/ConexaoDBStocker/atualiza_login.php");
    await http.post(url, body: {"login": login, "senha": senha, "id": "$id"});
  }

  updateSenha(int id, String random, int ns) async {
    var url = Uri.parse("http://$ip/ConexaoDBStocker/atualiza_senha.php");
    await http.post(url, body: {"senha": random, "ns": "$ns", "id": "$id"});
  }

  updateRTS(String de, String ate) async {
    var url = Uri.parse("http://$ip/ConexaoDBStocker/relatorio_total.php");
    await http.post(url, body: {
      "dedata": de,
      "atedata": ate,
    });
  }
}
