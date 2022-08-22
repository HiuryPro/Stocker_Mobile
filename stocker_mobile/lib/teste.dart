import 'dart:convert';

import 'package:http/http.dart' as http;

select(String query) async {
  const String ip = "192.168.3.9";
  dynamic body;
  var url = Uri.parse("http://$ip/ConexaoDBStocker/Select.php");
  http.Response response = await http.post(url, body: {'query': query});
  body = jsonDecode(response.body);

  return body;
}

insert(String query, List<String> lista) async {
  const String ip = "192.168.3.9";
  var url = Uri.parse("http://$ip/ConexaoDBStocker/Insert.php");
  await http.post(url, body: {'query': query, 'lista': jsonEncode(lista)});
}

update(String query, List<dynamic> lista) async {
  const String ip = "192.168.3.9";
  var url = Uri.parse("http://$ip/ConexaoDBStocker/Update.php");
  await http.post(url, body: {'query': query, 'lista': jsonEncode(lista)});
}

delete(String query) async {
  const String ip = "192.168.3.9";
  var url = Uri.parse("http://$ip/ConexaoDBStocker/Select.php");
  await http.post(url, body: {'query': query});
}

main() async {
  var deData = "01/06/2022";
  var ateData = "14/06/2022";
  await insert(
      "Insert into teste (nome, numero) VALUES (?,?)", ["teste2", "14"]);
  await update(
      "Update teste set nome = ? , numero = ? where id = 1", ['Gay', 24]);
  await delete("Delete from teste where id = 1");
  print(await select("SELECT * FROM teste"));
}
