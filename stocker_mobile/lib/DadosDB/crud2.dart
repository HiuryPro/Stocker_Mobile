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

  selectP() async {
    dynamic body;
    var url = Uri.parse("http://$ip/ConexaoDBStocker/produto.php");
    http.Response response = await http.get(url);
    body = jsonDecode(response.body);

    var dados = [];

    for (var row in body) {
      dados.add(row['id']);
      dados.add(row['nome']);
      dados.add(row['preco']);
      dados.add(row['descricao']);
    }
    return dados;
  }

  selectFP(String? produto, String? fornecedor) async {
    dynamic body;
    var url = Uri.parse("http://$ip/ConexaoDBStocker/fornecedorP.php");
    http.Response response = await http
        .post(url, body: {"produto": produto, "fornecedor": fornecedor});
    body = jsonDecode(response.body);

    var dados = [];

    for (var row in body) {
      dados.add(row['id']);
      dados.add(row['fornecedor']);
      dados.add(row['produto']);
      dados.add(row['preco']);
      dados.add(row['frete']);
    }
    print(dados);
    return dados;
  }
}
