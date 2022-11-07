import 'package:flutter/material.dart';

import 'package:stocker_mobile/Validacao_e_Gambiarra/drawertela.dart';
import 'package:stocker_mobile/services/supabase.databaseService.dart';

import '../Validacao_e_Gambiarra/voz.dart';
import 'package:collection/collection.dart';

class Estoque extends StatefulWidget {
  const Estoque({super.key});

  @override
  State<Estoque> createState() => _EstoqueState();
}

class _EstoqueState extends State<Estoque> {
  var drawerTela = DrawerTela();
  List<Map> estoque = [];
  var crud = DataBaseService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      var lista = await crud.selectInner(
          tabela: 'Estoque',
          select: "*, Produto!inner(IdProduto,NomeProduto)",
          where: {});

      for (var row in lista) {
        setState(() {
          estoque.add({
            'id': row['Produto']['IdProduto'],
            'produto': row['Produto']['NomeProduto'],
            'precoMPM': row['PrecoMPM'],
            'quantidade': row['Quantidade']
          });
        });
      }
      print(estoque);
      print(lista);
    });
  }

  Widget body() {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Center(
              child: ListView(
            shrinkWrap: true,
            children: [
              Center(child: Text("Funciona")),
              Center(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Center(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columns: _createColumns(), rows: createRows())),
                    )
                  ],
                ),
              ),
            ],
          )),
        ));
  }

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text("Identificador")),
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text('PrecoMPM')),
      DataColumn(label: Text('Quantidade')),
      DataColumn(label: Text('Total')),
    ];
  }

  List<DataRow> createRows() {
    return estoque
        .mapIndexed((index, book) => DataRow(
              cells: [
                DataCell(Text(book['id'].toString())),
                DataCell(Text(book['produto'].toString())),
                DataCell(Text(book['precoMPM'].toString())),
                DataCell(TextFormField(
                  initialValue: "${book['quantidade']}",
                  keyboardType: TextInputType.number,
                  onChanged: (text) {
                    setState(() {
                      if (text != '') {
                        book['quantidade'] = int.parse(text);
                      } else {
                        book['quantidade'] = 0;
                      }
                    });
                  },
                )),
                DataCell(Text("${book['quantidade'] * book['precoMPM']}"))
              ],
            ))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
                heroTag: null,
                child: Icon(Icons.phone),
                onPressed: () async {
                  print(this.context);
                  Voz.instance.context = this.context;
                  Voz.instance.opcao = 0;
                  await Voz.instance.initSpeechState();

                  await Voz.instance.initTts();
                  await Voz.instance.buscaComandos();
                  Voz.instance.startListening();
                })
          ],
        ),
        drawer: drawerTela.drawerTela(context),
        appBar: AppBar(),
        body: body());
  }
}
