import 'package:flutter/material.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/argumentosVoz.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/teste3.dart';

import 'drawertela.dart';
import 'errotela.dart';

class TesteFrog extends StatefulWidget {
  static const nomeDaRota = '/Teste3';
  const TesteFrog({super.key});

  @override
  State<TesteFrog> createState() => _TesteFrogState();
}

class _TesteFrogState extends State<TesteFrog> {
  Color color = Colors.green;
  bool troca = false;
  int count = 0;

  void trocaCor() {
    setState(() {
      if (color == Colors.green) {
        color = Colors.black;
      } else {
        color = Colors.green;
      }
      calculaCount();
    });
  }

  calculaCount() {
    setState(() {
      count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments;
    print(args);
    if (args != null) {
      args = args as ScreenArguments;
      return FrogColor(
        color: color,
        trocaColor: trocaCor,
        troca: troca,
        count: count,
        child: args.widget,
      );
    } else {
      return ErroTela();
    }
  }
}

class MyPage extends StatelessWidget {
  MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final frog = FrogColor.of(context);
    var drawerTela = DrawerTela();

    return Scaffold(
        appBar: AppBar(),
        drawer: drawerTela.drawerTela(context),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text('Troca Cor ${frog.count}',
                    style: TextStyle(color: frog.color)),
                ElevatedButton(
                  onPressed: frog.trocaColor,
                  child: Text('Trocando Cor ${frog.troca}'),
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          TesteFrog.nomeDaRota, (Route<dynamic> route) => false,
                          arguments: ScreenArguments(MyPage()));
                    },
                    child: Text("Navega"))
              ],
            ),
          ),
        ));
  }
}
