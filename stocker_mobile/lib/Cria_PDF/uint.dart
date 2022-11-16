import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stocker_mobile/Cria_PDF/chart.dart';

class Uint {
  // ignore: prefer_typing_uninitialized_variables
  var bytes;
  // ignore: prefer_typing_uninitialized_variables
  var bytes2;
  // ignore: prefer_typing_uninitialized_variables
  var image;

  pegaImagem() async {
    ScreenshotController screenshotController = ScreenshotController();
    bytes = await screenshotController.captureFromWidget(
      const MediaQuery(data: MediaQueryData(), child: Chart(item: 1)),
    );
    bytes2 = await screenshotController.captureFromWidget(
      const MediaQuery(
        data: MediaQueryData(),
        child: Chart(item: 2),
      ),
    );

    image = (await rootBundle.load("assets/images/Stocker_blue_transpN.png"))
        .buffer
        .asUint8List();
  }
}
