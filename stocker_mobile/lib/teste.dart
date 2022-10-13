import 'package:intl/intl.dart';

import 'package:stocker_mobile/services/supabase.databaseService.dart';

main() async {
  var crud = DataBaseService();
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
}
