import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../DadosDB/crud2.dart';

class Compra extends StatefulWidget {
  const Compra({Key? key}) : super(key: key);

  @override
  State<Compra> createState() => _CompraState();
}

class _CompraState extends State<Compra> {
  String produto = "";
  final items = ["teste", "teste2"];
  String? value;
  var db = CRUD2();

  @override
  void initState() {
    super.initState();
    items.clear();
    Future.delayed(Duration.zero, () async {
      var result = await db.selectP();

      for (int i = 0; i < result.length; i = i + 4) {
        setState(() {
          items.add(result[i + 1]);
        });
      }
    });
  }

  Widget body() {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
                child: ListView(shrinkWrap: true, children: [
              TextField(
                onChanged: (text) {
                  setState(() {
                    produto = text;
                  });
                },
                decoration: const InputDecoration(
                    labelText: "Produto", border: OutlineInputBorder()),
              ),
              const SizedBox(
                height: 15,
              ),
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: value,
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: items.map(buildMenuItem).toList(),
                      onChanged: (value) {
                        setState(() {
                          this.value = value;
                        });
                      }),
                ),
              ),
            ]))));
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(item,
            style: const TextStyle(
              fontSize: 20,
            )),
      ));

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: body());
  }
}
