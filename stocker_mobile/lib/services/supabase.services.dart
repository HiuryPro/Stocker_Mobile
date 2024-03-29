import 'dart:math';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:universal_html/html.dart';

import '../credentials/supabase.credentials.dart';

var url = window.location.href;

class AuthenticationService {
  static AuthenticationService auth = AuthenticationService();
  String email = "";
  Future<GotrueSessionResponse> signUp(
      {required BuildContext context,
      required String email,
      required String senha}) async {
    GotrueSessionResponse response =
        await SupaBaseCredentials.supaBaseClient.auth.signUp(email, senha);
    if (response.error == null) {
      // ignore: use_build_context_synchronously

      return response;
    } else {
      // ignore: use_build_context_synchronously

      return response;
    }
  }

  Future<GotrueSessionResponse> signIn(
      {required String email, required String senha}) async {
    GotrueSessionResponse response = await SupaBaseCredentials
        .supaBaseClient.auth
        .signIn(email: email, password: senha);

    return response;
  }

  Future<GotrueSessionResponse> signIn2(
      {required String email, required String senha}) async {
    GotrueSessionResponse response =
        await SupaBaseCredentials.supaBaseClient.auth.signIn(password: senha);

    return response;
  }

  Future<GotrueResponse> signOut() async {
    GotrueResponse response =
        await SupaBaseCredentials.supaBaseClient.auth.signOut();

    return response;
  }

  Future<GotrueJsonResponse> passwordReset({required String email}) async {
    this.email = email;
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
