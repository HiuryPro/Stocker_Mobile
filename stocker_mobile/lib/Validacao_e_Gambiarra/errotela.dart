import 'package:flutter/material.dart';
import 'package:stocker_mobile/Metodos_das_Telas/navegar.dart';

class ErroTela extends StatelessWidget {
  const ErroTela({super.key});

  @override
  Widget build(BuildContext context) {
    var navegar = Navegar();
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
            padding: EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                const Center(
                    child: Text('Erro', style: TextStyle(fontSize: 50))),
                ElevatedButton(
                    onPressed: () {
                      navegar.navegarEntreTela('/Home', context);
                    },
                    child: Text('Voltar ao Home'))
              ],
            )),
      ),
    );
  }
}
