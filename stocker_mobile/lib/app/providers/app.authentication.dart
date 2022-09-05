import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';

import '../../services/supabase.services.dart';

class AuthenticationNotifier extends ChangeNotifier {
  var auth = AuthenticationService();

  signUp(
      {required BuildContext context,
      required String email,
      required String senha}) async {
    await auth.signUp(context: context, email: email, senha: senha);
  }

  Future<GotrueSessionResponse> signIn(
      {required String email, required String senha}) async {
    return await auth.signIn(email: email, senha: senha);
  }
}
