import 'package:stocker_mobile/credentials/supabase.credentials.dart';
import 'package:supabase/supabase.dart';

class DataBaseService {
  insert({
    required String tabela,
    required Map<String, dynamic> map,
  }) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .insert(map)
          .execute();
      print(response.data);
    } catch (e) {
      print(e);
    }
  }

  dynamic select({
    required String tabela,
    required Map<String, dynamic> query,
  }) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .select()
          .match(query)
          .execute();

      return response.data;
    } catch (e) {
      print(e.toString());
    }
  }

  update(
      {required String tabela,
      required Map<String, dynamic> query,
      required Map<String, dynamic> alteracoes}) async {
    try {
      var response = await SupaBaseCredentials.supaBaseClient
          .from(tabela)
          .update(alteracoes)
          .match(query)
          .execute();
      print(response.status);
    } catch (e) {
      print(e.toString());
    }
  }
}
