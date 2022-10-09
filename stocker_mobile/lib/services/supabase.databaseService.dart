import 'package:stocker_mobile/credentials/supabase.credentials.dart';
import 'package:supabase/supabase.dart';

class DataBaseService {
  Future<dynamic> insert({
    required String tabela,
    required Map<String, dynamic> map,
  }) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .insert(map)
          .execute();
      print(response.error);
      return response.data;
    } catch (e) {
      print(e);
    }
  }

  dynamic selectWithoutFilter({
    required String tabela,
    required String select,
  }) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .select(select)
          .execute();

      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  dynamic selectComando(
      {required String tabela, required String select, required int id}) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .select(select)
          .or('IdEmpresa.is.null, IdEmpresa.eq.$id')
          .execute();

      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  dynamic selectInner(
      {required String tabela,
      required String select,
      required Map<String, dynamic> where}) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .select(select)
          .match(where)
          .execute();

      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  dynamic select({
    required String tabela,
    required String select,
    required Map<String, dynamic> where,
  }) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .select(select)
          .match(where)
          .execute();

      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  update(
      {required String tabela,
      required Map<String, dynamic> where,
      required Map<String, dynamic> setValue}) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .update(setValue)
          .match(where)
          .execute();
      print(response.status);
    } catch (e) {
      print(e.toString());
    }
  }

  delete({required String tabela, required Map<String, dynamic> where}) async {
    try {
      await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .delete()
          .match(where)
          .execute();
    } catch (e) {
      print(e.toString());
    }
  }
}
