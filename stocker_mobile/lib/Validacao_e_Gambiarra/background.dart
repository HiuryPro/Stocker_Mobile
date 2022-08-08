import 'package:flutter/material.dart';

import 'app_controller.dart';

class BackGround {
  Widget backImage(var context) {
    return AppController.instance.isDarkTheme
        ? SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child:
                Image.asset('assets/images/backblack.jpg', fit: BoxFit.cover))
        : SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/back2.jpg', fit: BoxFit.cover));
  }
}
