import 'package:mysql1/mysql1.dart';

class Teste {
  var conn;
  var results;

  criaConn() async {
    var settings = ConnectionSettings(
        host: 'localhost', port: 3306, user: 'root', db: 'stocker');
    conn = await MySqlConnection.connect(settings);
  }

  pegaDados() async {
    var userId = 1;
    var results = await conn.query(
        'select nome_produto, cliente from produto_venda where id = ?',
        [userId]);
  }

  listaDados() {
    for (var row in results) {
      print('Produto: ${row[0]}, Cliente: ${row[1]}');
    }
  }
}
