import 'package:http/http.dart' as http;

class CRUD2 {
  updateRTS(String de, String ate) async {
    int i = 1;
    var url =
        Uri.parse("http://192.168.3.9/ConexaoDBStocker/relatorio_total.php");
    await http.post(url, body: {
      "dedata": de,
      "atedata": ate,
    });
  }
}
