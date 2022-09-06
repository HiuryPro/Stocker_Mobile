import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarouTeste extends StatefulWidget {
  const CarouTeste({super.key});

  @override
  State<CarouTeste> createState() => _CarouTesteState();
}

class _CarouTesteState extends State<CarouTeste> {
  var fieldText = TextEditingController();

  var fieldText2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: ListView(
              shrinkWrap: true,
              children: [
                CarouselSlider(
                    items: [endereco(), endereco()],
                    options: CarouselOptions(
                      initialPage: 0,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                      enableInfiniteScroll: false,
                    )),
                Center(
                    child: ElevatedButton(
                        onPressed: () {}, child: const Text("Cadastrar"))),
              ],
            ),
          )),
    );
  }

  Widget endereco() {
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          shrinkWrap: true,
          children: [
            TextField(
              controller: fieldText,
              decoration: const InputDecoration(label: Text("Email")),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: fieldText2,
              decoration: const InputDecoration(label: Text("Senha")),
            ),
          ],
        ),
      ),
    );
  }
}
