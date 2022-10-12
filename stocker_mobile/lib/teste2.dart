import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // The following list is already sorted by id
  List<Map> preCompra = [];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('DataTable Demo'),
        ),
        body: ListView(
          children: [
            DataTable(columns: _createColumns(), rows: createRows()),
            const SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    preCompra.add({
                      'produto': 'Maçâ',
                      'fornecedor': 'Mario',
                      'quantidade': 10,
                      'preco': 5,
                      'frete': 2,
                      'selecionado': true
                    });
                    print(preCompra);
                  });
                },
                child: Text("Adiciona Linha")),
            SizedBox(height: 15),
            ElevatedButton(
                onPressed: () {
                  List<Map<dynamic, dynamic>?> lista = [];
                  for (var value in preCompra) {
                    if (value['selecionado']) {
                      print(value);
                      value.removeWhere((key, value) => key == 'selecionado');
                      lista.add(value);
                    }
                  }
                  lista.removeWhere((element) => element == null);
                  print(lista);
                },
                child: Text("Imprimi"))
          ],
        ),
      ),
    );
  }

  List<DataColumn> _createColumns() {
    return [
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text('Fornecedor')),
      DataColumn(label: Text('Quantidade')),
      DataColumn(label: Text('Preco')),
      DataColumn(label: Text('Frete')),
      DataColumn(label: Text('Total')),
    ];
  }

  List<DataRow> createRows() {
    return preCompra
        .mapIndexed((index, book) => DataRow(
                cells: [
                  DataCell(Text(book['produto'])),
                  DataCell(Text(book['fornecedor'])),
                  DataCell(TextFormField(
                    initialValue: "${book['quantidade']}",
                    keyboardType: TextInputType.number,
                    onChanged: (text) {
                      setState(() {
                        book['quantidade'] = int.parse(text);
                      });
                    },
                  )),
                  DataCell(Text("${book['preco']}")),
                  DataCell(Text("${book['frete']}")),
                  DataCell(Text(
                      "${(book['quantidade'] * book['preco']) + book['frete']}"))
                ],
                selected: book['selecionado'],
                onSelectChanged: (bool? selected) {
                  setState(() {
                    preCompra[index]['selecionado'] = selected!;
                    print(preCompra);
                  });
                }))
        .toList();
  }
}
