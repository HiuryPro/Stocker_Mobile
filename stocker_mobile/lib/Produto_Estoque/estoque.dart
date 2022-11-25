import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
  Map<String, int> produtos = {};
  String? produtoSelecionado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration.zero, () async {
      var lista =
          await crud.selectInner(tabela: 'Produto', select: "*", where: {});
      for (var row in lista) {
        setState(() {
          produtos.addAll({row['NomeProduto']: row['IdProduto']});
        });
      }
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
              Container(
                decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF0080d9), width: 2),
                    borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                      value: produtoSelecionado,
                      menuMaxHeight: 200,
                      hint: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Produtos"),
                      ),
                      borderRadius: BorderRadius.circular(12),
                      isExpanded: true,
                      items: produtos.keys.toList().map(buildMenuItem).toList(),
                      onChanged: (value) async {
                        setState(() {
                          produtoSelecionado = value;
                          estoque.clear();
                        });
                        var lista = await crud.selectInner(
                            tabela: 'Estoque',
                            select:
                                '*, Lote!inner(*, Produto!inner(IdProduto, NomeProduto))',
                            where: {
                              'Lote.Produto.IdProduto':
                                  produtos[produtoSelecionado]
                            });

                        print(lista);

                        for (var row in lista) {
                          setState(() {
                            estoque.add({
                              'numl': row['Lote']['NumeroLote'],
                              'produto': row['Lote']['Produto']['NomeProduto'],
                              'precoMPM': row['PrecoMPM'],
                              'quantidade': row['Quantidade'],
                              'dataV': row['Lote']['DataVencimento'] != null
                                  ? DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          row['Lote']['DataVencimento']))
                                  : null,
                              'dataF': row['Lote']['DataFabricacao'] != null
                                  ? DateFormat('dd/MM/yyyy').format(
                                      DateTime.parse(
                                          row['Lote']['DataFabricacao']))
                                  : null
                            });
                          });
                        }
                      }),
                ),
              ),
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

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(item,
            style: const TextStyle(
              fontSize: 20,
            )),
      ));

  List<DataColumn> _createColumns() {
    return const [
      DataColumn(label: Text("Número Lote")),
      DataColumn(label: Text("Produto")),
      DataColumn(label: Text('PrecoMPM')),
      DataColumn(label: Text('Quantidade')),
      DataColumn(label: Text('Data de Fabricação')),
      DataColumn(label: Text('Data de Vencimento')),
      DataColumn(label: Text('Total')),
    ];
  }

  List<DataRow> createRows() {
    return estoque
        .mapIndexed((index, book) => DataRow(
              cells: [
                DataCell(Text(book['numl'].toString())),
                DataCell(Text(book['produto'].toString())),
                DataCell(Text(book['precoMPM'].toString())),
                DataCell(Text("${book['quantidade']}")),
                DataCell(Text(book['dataF'].toString())),
                DataCell(Text("${book['dataV']}")),
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
