import 'package:intl/intl.dart';

import 'package:stocker_mobile/services/supabase.databaseService.dart';

main() async {
  Map<int, int> vendaCliente = {};
  for (int i = 0; i < 10; i++) {
    vendaCliente.addAll({i: i + 1});
  }

  print(vendaCliente);
  /*
  var crud = DataBaseService();

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
    'Data': DateFormat.yMMMd().add_Hm().format(DateTime.now()),
    'Hora': DateFormat.Hms().format(DateTime.now())
  });
  print(teste);
  print(teste[0]['IdTeste']);

  await crud.selectNovo(function: 'teste');
  print(apenasNumeros("ola meu nome é 35"));
  */
  print(DateFormat("dd/MM/yyyy").parse('28/12/2002'));
}
