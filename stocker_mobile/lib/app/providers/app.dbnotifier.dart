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
    required Map<String, dynamic> query,
  }) async {
    return await dataBService.select(tabela: tabela, query: query);
  }

  update(
      {required String tabela,
      required Map<String, dynamic> query,
      required Map<String, dynamic> alteracoes}) async {
    await dataBService.update(
        tabela: tabela, query: query, alteracoes: alteracoes);
  }
}
