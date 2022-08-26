import 'dart:convert';
import 'package:http/http.dart' as http;

class SendMail {
  Future sendEmailWelcome({
    required String abrevia,
    required String cnpj,
    required String name,
    required String email,
  }) async {
    const String serviceId = 'service_jujm37e';
    const String templateID = 'template_vm29sg3';
    const String publicKey = 'jgtTsuJrMjpXJwWAR';
    const String introducao = 'Bem vindo ao Stocker';
    String message = "Seu login é : $abrevia <br/> Sua senha é :  $cnpj";
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateID,
          'template_params': {
            'introducao': introducao,
            'user_name': name,
            'email': email,
            'message': message,
          },
          'user_id': publicKey,
        }));
  }

  Future sendEmailChangePass(
      {required String email,
      required String password,
      required String name}) async {
    const String serviceId = 'service_jujm37e';
    const String templateID = 'template_vm29sg3';
    const String publicKey = 'jgtTsuJrMjpXJwWAR';
    const String introducao = 'Mudança de senha';
    String message = "Sua nova senha é $password";
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");

    await http.post(url,
        headers: {
          'origin': 'http://localhost',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateID,
          'template_params': {
            'introducao': introducao,
            'user_name': name,
            'email': email,
            'message': message,
          },
          'user_id': publicKey,
        }));
  }
}
