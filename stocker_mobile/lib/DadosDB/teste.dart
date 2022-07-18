import 'dart:math';

class Teste {
  geraStringAleatoria() {
    String stringAleatoria = '';
    String caracteres =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    for (var i = 0; i < 8; i++) {
      stringAleatoria += caracteres[Random().nextInt(caracteres.length)];
    }

    return stringAleatoria;
  }
}
