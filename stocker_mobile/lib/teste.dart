import 'package:intl/intl.dart';
import 'package:stocker_mobile/credentials/supabase.credentials.dart';

import 'package:stocker_mobile/services/supabase.databaseService.dart';
import 'package:supabase/supabase.dart';

main() async {
  Map<int, int> vendaCliente = {};
  for (int i = 0; i < 10; i++) {
    vendaCliente.addAll({i: i + 1});
  }

  print(vendaCliente);
  var crud = DataBaseService();
/*
  int apenasNumeros(String idNoText) {
    String soId = idNoText.replaceAll(RegExp(r'[^0-9]'), '');
    return int.parse(soId);
  }

  print(await crud.selectInner(
      tabela: "ItemCompra",
      select:
          "*, FornecedorProduto!inner(Produto!inner(*), Fornecedor!inner(*), Preco)",
      where: {}));

  print(DateFormat.Hms().format(DateTime.now()));
  print(DateFormat("dd/MM/yyyy")
      .parse(DateFormat("dd/MM/yyyy").format(DateTime.now())));

  var teste = await crud.insert(tabela: 'Teste', map: {
    'Data': ,
    'Hora': DateFormat.Hms().format(DateTime.now())
  });
  print(teste);
  print(teste[0]['IdTeste']);

  await crud.selectNovo(function: 'teste');
  print(apenasNumeros("ola meu nome é 35"));
  */

  print(DateFormat.yMMMd()
      .add_Hm()
      .format(DateFormat("dd/MM/yyyy").parse('28/12/2002')));

  Map<String, String> map = {"teste": 'Teste1', 'teste2': 'teste2'};
  print(map);
  print(map.length);
  map.forEach((key, value) {
    print(key);
  });
  await SupaBaseCredentials.supaBaseClient.rpc('totalCompra2').execute();

  var response =
      await SupaBaseCredentials.supaBaseClient.rpc('compra').execute();
  print(response.data);

  /*var response2 = await SupaBaseCredentials.supaBaseClient.rpc(
      'relatorioCompra',
      params: {'data1': '12/05/2022', 'data2': '12/12/2022'}).execute();
  print(response2.data);
  */
  var response2 = await SupaBaseCredentials.supaBaseClient.rpc(
      'relatoriocompra',
      params: {'data1': "23/04/2022", 'data2': '23/11/2022'}).execute();
  print(response2.data);
}
