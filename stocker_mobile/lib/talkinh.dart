import 'package:flutter/material.dart';

class TalkinH extends StatefulWidget {
  const TalkinH({super.key});

  @override
  State<TalkinH> createState() => _TalkinHState();
}

class _TalkinHState extends State<TalkinH> {
  var imagem = "assets/hiury/calado.png";

  Widget tela() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
                child: ListView(shrinkWrap: true, children: [
              GestureDetector(
                onTap: () async {
                  setState(() {
                    imagem = "assets/hiury/fechado.png";
                  });

                  await Future.delayed(Duration(milliseconds: 300));

                  setState(() {
                    imagem = "assets/hiury/calado.png";
                  });
                },
                child: Center(child: Image.asset(imagem)),
              )
            ]))));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tela(),
    );
  }
}
