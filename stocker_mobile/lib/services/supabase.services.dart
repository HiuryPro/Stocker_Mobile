import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import '../credentials/supabase.credentials.dart';

class AuthenticationService {
  signUp(
      {required BuildContext context,
      required String email,
      required String senha}) async {
    GotrueSessionResponse response =
        await SupaBaseCredentials.supaBaseClient.auth.signUp(email, senha);
    mensagem(context, response);
    var user = SupaBaseCredentials.supaBaseClient.auth.user()!.email;
    print(user);
  }

  ScaffoldFeatureController mensagem(var context, var response) {
    return response.error == null
        ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                "Cadastro feito com Sucesso!: Email de Confirmação eviado")))
        : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                "Erro no Cadastro: ${response.error!.message.toString()}")));
  }
}
