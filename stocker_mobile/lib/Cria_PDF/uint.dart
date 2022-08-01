import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screenshot/screenshot.dart';
import 'package:stocker_mobile/Cria_PDF/chart.dart';
import 'package:stocker_mobile/Cria_PDF/chart2.dart';

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
      const MediaQuery(data: MediaQueryData(), child: Chart()),
    );
    bytes2 = await screenshotController.captureFromWidget(
      const MediaQuery(
        data: MediaQueryData(),
        child: Chart2(),
      ),
    );

    image = (await rootBundle.load("assets/images/Stocker_blue_transp.png"))
        .buffer
        .asUint8List();
  }
}
