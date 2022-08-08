import 'package:flutter/material.dart';

class AppController extends ChangeNotifier {
  static AppController instance = AppController();

  bool isDarkTheme = false;
  String img = "assets/images/back2.jpg";

  changeTheme() {
    isDarkTheme = !isDarkTheme;
    if (isDarkTheme) {
      img = "assets/images/backblack.jpg";
    } else {
      img = "assets/images/back2.jpg";
    }
    notifyListeners();
  }
}
