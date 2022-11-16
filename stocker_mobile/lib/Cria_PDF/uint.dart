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

  pegaImagem(int opcao, String? deData, String? ateData) async {
    ScreenshotController screenshotController = ScreenshotController();
    bytes = await screenshotController.captureFromWidget(
      MediaQuery(
          data: MediaQueryData(),
          child: Chart(item: 1, opcao: opcao, data1: deData, data2: ateData)),
    );
    bytes2 = await screenshotController.captureFromWidget(
      MediaQuery(
        data: MediaQueryData(),
        child: Chart(item: 2, opcao: opcao, data1: deData, data2: ateData),
      ),
    );

    image = (await rootBundle.load("assets/images/Stocker_blue_transpN.png"))
        .buffer
        .asUint8List();
  }
}
