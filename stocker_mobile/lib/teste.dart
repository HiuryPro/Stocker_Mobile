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
  print(DateFormat("dd/MM/yyyy").format(DateTime.now()));
}
