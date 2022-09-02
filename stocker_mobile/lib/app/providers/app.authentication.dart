import 'package:flutter/material.dart';

import '../../services/supabase.services.dart';

class AuthenticationNotifier extends ChangeNotifier {
  var auth = AuthenticationService();

  signUp(
      {required BuildContext context,
      required String email,
      required String senha}) async {
    await auth.signUp(context: context, email: email, senha: senha);
  }
}
