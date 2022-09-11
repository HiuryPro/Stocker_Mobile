import 'dart:collection';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:stocker_mobile/Validacao_e_Gambiarra/maskara.dart';

import 'Validacao_e_Gambiarra/app_controller.dart';
import 'Validacao_e_Gambiarra/inscricaoestadual.dart';
import 'Validacao_e_Gambiarra/validacao.dart';

class CarouTeste extends StatefulWidget {
  const CarouTeste({super.key});

  @override
  State<CarouTeste> createState() => _CarouTesteState();
}

class _CarouTesteState extends State<CarouTeste> {
  var valida = Validacao();
  var inscE = InscE();
  var maskaraIE = MaskaraInscE();

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

  MaskTextInputFormatter maskFormatterInscE = MaskTextInputFormatter(
      mask: '#',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskFormatterCnpj = MaskTextInputFormatter(
      mask: '##.###.###/####-##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskFormatterTelefone = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  List<TextEditingController> textControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  List<String?> mensagemDeErro = [
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null,
    null
  ];

  var carouselController = CarouselController();

  int indexAtivo = 0;
  bool enabled = false;

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
                items: [empresa(), endereco()],
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
                      duration: Duration(milliseconds: 500));
                });
              },
            )),
            const SizedBox(
              height: 20,
            ),
            Center(
                child: ElevatedButton(
                    onPressed: () {
                      if (isPreechido()) {
                        if (valida
                            .validacnpj(maskFormatterCnpj.getUnmaskedText())) {
                          print("Campos estão preenchidos e cnpj valido");
                        } else {
                          setState(() {
                            mensagemDeErro[1] = "CNPJ invalido";
                          });
                          print("Campos estão preenchidos e cnpj invalido");
                        }
                      } else {
                        if (valida
                            .validacnpj(maskFormatterCnpj.getUnmaskedText())) {
                        } else {
                          setState(() {
                            mensagemDeErro[1] = "CNPJ invalido";
                          });
                        }
                        print("Algum campo está vazio");
                      }
                    },
                    child: const Text("Cadastrar"))),
          ],
        ),
      ),
    );
  }

  Widget empresa() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: Text(
                "Dados da Empresa",
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: textControllers[0],
              decoration: InputDecoration(
                  label: Text("Nome"), errorText: mensagemDeErro[0]),
              onChanged: (text) {
                setState(() {
                  enabled = true;
                  mensagemDeErro[0] = null;
                  print(textControllers[0].text);
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[1],
              inputFormatters: [maskFormatterCnpj],
              decoration: InputDecoration(
                  label: Text("Cnpj"), errorText: mensagemDeErro[1]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[1] = null;
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
                      maskFormatterInscE =
                          maskaraIE.estadoMascara((estado![0] + estado![1]));
                    }),
              ),
            ),
            TextField(
              controller: textControllers[2],
              inputFormatters: [maskFormatterInscE],
              decoration: InputDecoration(
                  label: Text("Inscrição estadual"),
                  errorText: mensagemDeErro[1]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[2] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[3],
              inputFormatters: [maskFormatterTelefone],
              decoration: InputDecoration(
                  label: Text("Telefone"), errorText: mensagemDeErro[2]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[3] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[4],
              decoration: InputDecoration(
                  label: Text("Ganho Mensal"), errorText: mensagemDeErro[3]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[4] = null;
                });
              },
            ),
          ],
        ),
      ),
    );
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

  Widget endereco() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            const Center(
              child: Text(
                "Endereço da Empresa",
                style: TextStyle(fontSize: 25),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextField(
              controller: textControllers[5],
              decoration: InputDecoration(
                  label: Text("Logradouro"), errorText: mensagemDeErro[4]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[5] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[6],
              decoration: InputDecoration(
                  label: Text("Numero"), errorText: mensagemDeErro[5]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[6] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[7],
              decoration: InputDecoration(
                  label: Text("Bairro"), errorText: mensagemDeErro[6]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[7] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[8],
              decoration: InputDecoration(
                  label: Text("Cidade"), errorText: mensagemDeErro[7]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[8] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[9],
              decoration: InputDecoration(
                  label: Text("Estado"), errorText: mensagemDeErro[8]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[9] = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  bool isPreechido() {
    bool isPreenchido = true;
    for (int i = 0; i < textControllers.length; i++) {
      if (textControllers[i].text == "") {
        setState(() {
          mensagemDeErro[i] = "Campo está vazio";
        });
        isPreenchido = false;
      } else {}
    }
    return isPreenchido;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              AppController.instance.img,
              fit: BoxFit.cover,
            )),
        _body()
      ],
    ));
  }
}
