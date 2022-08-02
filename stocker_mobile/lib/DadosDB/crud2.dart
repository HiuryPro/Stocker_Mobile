import 'dart:convert';

import 'package:http/http.dart' as http;

class CRUD2 {
  final String ip = "192.168.3.9";

  updateRTS(String de, String ate) async {
    var url = Uri.parse("http://$ip/ConexaoDBStocker/relatorio_total.php");
    await http.post(url, body: {
      "dedata": de,
      "atedata": ate,
    });
  }

  selectRT() async {
    dynamic body;
    var url = Uri.parse("http://$ip/ConexaoDBStocker/selectRT.php");
    http.Response response = await http.get(url);
    body = jsonDecode(response.body);

    var dados = [];

    for (var row in body) {
      dados.add(row['id']);
      dados.add(row['nome_produto']);
      dados.add(row['qtd_total']);
      dados.add(row['preco_total']);
    }
    return dados;
  }
}
