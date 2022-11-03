import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:universal_html/html.dart';

import '../credentials/supabase.credentials.dart';

var url = window.location.href;

class AuthenticationService {
  static AuthenticationService auth = AuthenticationService();
  signUp(
      {required BuildContext context,
      required String email,
      required String senha}) async {
    GotrueSessionResponse response =
        await SupaBaseCredentials.supaBaseClient.auth.signUp(email, senha);
    if (response.error == null) {
      // ignore: use_build_context_synchronously
      mensagem(context, response);
    } else {
      // ignore: use_build_context_synchronously
      mensagem(context, response);
    }
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

  Future<GotrueSessionResponse> signIn(
      {required String email, required String senha}) async {
    GotrueSessionResponse response = await SupaBaseCredentials
        .supaBaseClient.auth
        .signIn(email: email, password: senha);

    return response;
  }

  Future<GotrueResponse> signOut(
      {required String email, required String senha}) async {
    GotrueResponse response =
        await SupaBaseCredentials.supaBaseClient.auth.signOut();

    return response;
  }

  Future<GotrueJsonResponse> passwordReset(
      {required String email, required String url}) async {
    GotrueJsonResponse response = await SupaBaseCredentials
        .supaBaseClient.auth.api
        .resetPasswordForEmail(email);

    return response;
  }

  Future<GotrueUserResponse> passwordChange({required String novaSenha}) async {
    GotrueUserResponse response = await SupaBaseCredentials.supaBaseClient.auth
        .update(UserAttributes(password: novaSenha));

    return response;
  }

  Future<GotrueUserResponse> passwordAltera() async {
    GotrueUserResponse response = await SupaBaseCredentials.supaBaseClient.auth
        .update(UserAttributes(password: '1234567'));

    return response;
  }
}
