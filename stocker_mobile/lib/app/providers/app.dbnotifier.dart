import 'package:flutter/material.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

class DataBaseNotifier extends ChangeNotifier {
  final DataBaseService dataBService = DataBaseService();

  insert({
    required String tabela,
    required Map<String, dynamic> map,
  }) async {
    await dataBService.insert(tabela: tabela, map: map);
  }

  dynamic select({
    required String tabela,
    required String select,
    required Map<String, dynamic> where,
  }) async {
    return await dataBService.select(tabela: tabela, select: select, where: where);
  }

  update(
      {required String tabela,
      required Map<String, dynamic> where,
      required Map<String, dynamic> setValue}) async {
    await dataBService.update(
        tabela: tabela, where: where, setValue: setValue);
  }

   delete({required String tabela, required Map<String, dynamic> where}) async{
   await dataBService.delete(tabela: tabela, where: where);
  }
}
