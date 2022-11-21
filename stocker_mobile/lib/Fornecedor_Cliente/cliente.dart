import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/validacao.dart';

import '../Validacao_e_Gambiarra/drawertela.dart';
import '../services/supabase.databaseService.dart';

class Cliente extends StatefulWidget {
  const Cliente({super.key});

  @override
  State<Cliente> createState() => _ClienteState();
}

class _ClienteState extends State<Cliente> {
  var valida = Validacao();
  var carouselController = CarouselController();
  var crud = DataBaseService();
  var drawer = DrawerTela();

  int indexAtivo = 0;
  Map<String, TextEditingController> controllersEndereco = {
    'logradouro': TextEditingController(),
    'numero': TextEditingController(),
    'bairro': TextEditingController(),
    'cidade': TextEditingController(),
    'cep': TextEditingController(),
    'complemento': TextEditingController(),
  };

  Map<String, String?> mensagemDeErroEnd = {
    'logradouro': null,
    'numero': null,
    'bairro': null,
    'cidade': null,
    'cep': null,
    'complemento': null,
  };

  String? estado;
  List<String> estados = [
    "AC Acre",
    "AL Alagoas",
    "AP Amapá",
    "AM Amazonas",
    "BA Bahia",
    "CE Ceará",
    "DF Distrito Federal",
    "ES Espírito Santo",
    "GO Goiás",
    "MA Maranhão",
    "MT Mato Grosso",
    "MS Mato Grosso do Sul",
    "MG Minas Gerais",
    "PA Pará",
    "PB Paraíba",
    "PR Paraná",
    "PE Pernambuco",
    "PI Piauí",
    "Rio de Janeiro - RJ",
    "RN Rio Grande do Norte",
    "RS Rio Grande do Sul",
    "RO Rondônia",
    "RR Roraima",
    "SC Santa Catarina",
    "SP São Paulo",
    "SE Sergipe",
    "TO Tocantins"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: drawer.drawerTela(context),
      body: _body(),
    );
  }

  Map<String, TextEditingController> controllersCliente = {
    'nome': TextEditingController(),
    'cpf': TextEditingController(),
    'telefone': TextEditingController(),
    'email': TextEditingController(),
    'desconto': TextEditingController(),
    'descricao': TextEditingController(),
    'ocupacao': TextEditingController()
  };

  Map<String, String?> mensagemDeErroClie = {
    'nome': null,
    'cpf': null,
    'telefone': null,
    'email': null,
    'desconto': null,
    'descricao': null,
    'ocupacao': null
  };
  var maskFormatterTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskFormatterCpf = MaskTextInputFormatter(
      mask: '###.###.###-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  Widget _body() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView(
          shrinkWrap: true,
          children: [
            CarouselSlider(
                items: [cliente(), endereco()],
                carouselController: carouselController,
                options: CarouselOptions(
                  height: MediaQuery.of(context).size.height - 200,
                  initialPage: 0,
                  viewportFraction: 1,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      indexAtivo = index;
                    });
                  },
                  enableInfiniteScroll: false,
                )),
            Center(
                child: AnimatedSmoothIndicator(
              activeIndex: indexAtivo,
              count: 2,
              onDotClicked: (index) {
                setState(() {
                  indexAtivo = index;
                  carouselController.animateToPage(indexAtivo,
                      duration: const Duration(milliseconds: 500));
                });
              },
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () async {
                      int id = -1;

                      if (isPreenchido() && estado != null) {
                        if (valida.iscpf(maskFormatterCpf.getUnmaskedText())) {
                          var pessoa =
                              await crud.insert(tabela: 'Pessoa', map: {
                            'Nome': controllersCliente['nome']!.text,
                            'CPF': maskFormatterCpf.getUnmaskedText(),
                            'Telefone': maskFormatterTelefone.getUnmaskedText(),
                            'Email': controllersCliente['email']!.text
                          });

                          print(pessoa);

                          var cliente =
                              await crud.insert(tabela: 'Cliente', map: {
                            'IdCliente': pessoa[0]['IdPessoa'],
                            'Desconto': double.parse(
                                controllersCliente['desconto']!.text),
                            'Ocupacao': controllersCliente['ocupacao']!.text,
                            'Descricao': controllersCliente['descricao']!.text
                          });

                          print(cliente);

                          var endereco =
                              await crud.insert(tabela: 'Endereco', map: {
                            'IdPessoa': cliente[0]['IdCliente'],
                            'logradouro':
                                controllersEndereco['logradouro']!.text,
                            'numero':
                                int.parse(controllersEndereco['numero']!.text),
                            'bairro': controllersEndereco['bairro']!.text,
                            'cidade': controllersEndereco['cidade']!.text,
                            'estado': estado,
                            'cep': controllersEndereco['cep']!.text,
                            'complemento':
                                controllersEndereco['complemento']!.text
                          });

                          print(endereco);

                          print("Campos estão preenchidos e cpf valido");
                        } else {
                          setState(() {
                            mensagemDeErroClie['cpf'] = "Cpf invalido";
                          });
                          print("Campos estão preenchidos e cnpj invalido");
                        }
                      } else {
                        print("Algum campo está vazio");
                      }
                    },
                    child: const Text("Cadastrar"))),
          ],
        ),
      ),
    );
  }

  Widget cliente() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: Text(
                "Dados Cliente",
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllersCliente['nome'],
              decoration: InputDecoration(
                  label: const Text("Nome"),
                  errorText: mensagemDeErroClie['nome']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroClie['nome'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              inputFormatters: [maskFormatterCpf],
              controller: controllersCliente['cpf'],
              decoration: InputDecoration(
                  label: const Text("Cpf"),
                  errorText: mensagemDeErroClie['cpf']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroClie['cpf'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              inputFormatters: [maskFormatterTelefone],
              controller: controllersCliente['telefone'],
              decoration: InputDecoration(
                  label: const Text("Telefone"),
                  errorText: mensagemDeErroClie['telefone']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroClie['telefone'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersCliente['email'],
              decoration: InputDecoration(
                  label: const Text("Email"),
                  errorText: mensagemDeErroClie['email']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroClie['email'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersCliente['ocupacao'],
              decoration: InputDecoration(
                  label: const Text("Ocupação"),
                  errorText: mensagemDeErroClie['ocupacao']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroClie['ocupacao'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersCliente['desconto'],
              decoration: InputDecoration(
                  label: const Text("Desconto"),
                  errorText: mensagemDeErroClie['desconto']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroClie['desconto'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              maxLines: 4,
              keyboardType: TextInputType.multiline,
              controller: controllersCliente['descricao'],
              decoration: InputDecoration(
                  label: const Text("Descricao"),
                  errorText: mensagemDeErroClie['descricao']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroClie['descricao'] = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget endereco() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: Text(
                "Endereço do Cliente",
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: controllersEndereco['logradouro'],
              decoration: InputDecoration(
                  label: const Text("Logradouro"),
                  errorText: mensagemDeErroEnd['logradouro']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroEnd['logradouro'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersEndereco['numero'],
              decoration: InputDecoration(
                  label: const Text("Numero"),
                  errorText: mensagemDeErroEnd['numero']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroEnd['numero'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersEndereco['bairro'],
              decoration: InputDecoration(
                  label: const Text("Bairro"),
                  errorText: mensagemDeErroEnd['bairro']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroEnd['bairro'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersEndereco['cidade'],
              decoration: InputDecoration(
                  label: const Text("Cidade"),
                  errorText: mensagemDeErroEnd['cidade']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroEnd['cidade'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersEndereco['cep'],
              decoration: InputDecoration(
                  label: const Text("CEP"),
                  errorText: mensagemDeErroEnd['cep']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroEnd['cep'] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF0080d9), width: 2),
                  borderRadius: BorderRadius.circular(12)),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                    value: estado,
                    menuMaxHeight: 200,
                    hint: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text("Estados"),
                    ),
                    borderRadius: BorderRadius.circular(12),
                    isExpanded: true,
                    items: estados.map(buildMenuItem).toList(),
                    onChanged: (value) async {
                      setState(() {
                        estado = value;
                      });
                    }),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: controllersEndereco['complemento'],
              decoration: InputDecoration(
                  label: const Text("Complemento"),
                  errorText: mensagemDeErroEnd['complemento']),
              onChanged: (text) {
                setState(() {
                  mensagemDeErroEnd['complemento'] = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isPreenchido() {
    bool isPreenchido = true;
    controllersCliente.forEach((key, value) {
      if (value.text == "") {
        isPreenchido = false;
      }
    });
    controllersEndereco.forEach((key, value) {
      if (value.text == "") {
        isPreenchido = false;
      }
    });

    return isPreenchido;
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
}
