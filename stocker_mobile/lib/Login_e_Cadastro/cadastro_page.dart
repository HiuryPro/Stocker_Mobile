import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:supabase/supabase.dart';

import '../Validacao_e_Gambiarra/app_controller.dart';
import '../Validacao_e_Gambiarra/inscricaoestadual.dart';
import '../Validacao_e_Gambiarra/maskara.dart';
import '../Validacao_e_Gambiarra/validacao.dart';
import 'inserecadastro.dart';

class CadPage extends StatefulWidget {
  const CadPage({Key? key}) : super(key: key);

  @override
  State<CadPage> createState() => _CadPageState();
}

class _CadPageState extends State<CadPage> {
  var valida = Validacao();
  var inscE = InscE();
  var maskaraIE = MaskaraInscE();
  var insereDB = InsereCadastro();

  var count = 0;

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

  var maskFormatterCpf = MaskTextInputFormatter(
      mask: '###.###.###-##',
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
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
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
                items: [administrador(), empresa(), endereco()],
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
              count: 3,
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
                      print(AppController.instance.response!.user!.id);
                      if (isPreechido()) {
                        if (valida.validacnpj(
                                maskFormatterCnpj.getUnmaskedText()) &&
                            valida.iscpf(maskFormatterCpf.getUnmaskedText())) {
                          if (inscE.valida(maskFormatterInscE.getUnmaskedText(),
                              estado!.substring(0, 2))) {
                            await insereDB.insereAdministrador(
                                AppController.instance.response!,
                                textControllers[0].text,
                                maskFormatterTelefone.getUnmaskedText(),
                                maskFormatterCpf.getUnmaskedText());

                            id = await insereDB.insereEmpresa(
                                AppController.instance.response!, [
                              textControllers[2].text,
                              maskFormatterCnpj.getUnmaskedText(),
                              maskFormatterInscE.getUnmaskedText(),
                              textControllers[5].text,
                              textControllers[6].text
                            ]);

                            await insereDB.insereEndereco([
                              id,
                              textControllers[7].text,
                              textControllers[8].text,
                              textControllers[9].text,
                              textControllers[10].text,
                              estado,
                              textControllers[11].text,
                              textControllers[12].text
                            ]);
                          } else {
                            mensagemDeErro[4] = "Inscrição estadual invalida";
                          }
                          print("Campos estão preenchidos e cnpj valido");
                          // ignore: use_build_context_synchronously
                          Navigator.pushNamedAndRemoveUntil(
                              context, '/Home', (route) => false);
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

  Widget administrador() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Center(
          child: ListView(shrinkWrap: true, children: [
        TextField(
          controller: textControllers[0],
          decoration: InputDecoration(
            labelText: 'Nome do Administrador',
            errorText: mensagemDeErro[0],
            border: const OutlineInputBorder(),
          ),
          onChanged: (text) {
            setState(() {
              mensagemDeErro[0] = null;
            });
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
          inputFormatters: [maskFormatterCpf],
          controller: textControllers[13],
          decoration: InputDecoration(
            labelText: 'CPF',
            errorText: mensagemDeErro[13],
            border: const OutlineInputBorder(),
          ),
          onChanged: (text) {
            setState(() {
              mensagemDeErro[13] = null;
            });
          },
        ),
        const SizedBox(
          height: 15,
        ),
        TextField(
            controller: textControllers[1],
            inputFormatters: [maskFormatterTelefone],
            onChanged: (text) {
              setState(() {
                mensagemDeErro[1] = null;
              });
            },
            decoration: InputDecoration(
              labelText: 'Telefone',
              errorText: mensagemDeErro[1],
              border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red)),
            )),
      ])),
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
              controller: textControllers[2],
              decoration: InputDecoration(
                  label: const Text("Nome"), errorText: mensagemDeErro[2]),
              onChanged: (text) {
                setState(() {
                  enabled = true;
                  mensagemDeErro[2] = null;
                  print(textControllers[0].text);
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[3],
              inputFormatters: [maskFormatterCnpj],
              decoration: InputDecoration(
                  label: const Text("Cnpj"), errorText: mensagemDeErro[3]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[3] = null;
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

                        count = 0;
                        if (!(estado!.substring(0, 2) == "BA" ||
                            estado!.substring(0, 2) == "TO")) {
                          maskFormatterInscE = maskaraIE.estadoMascara(
                              uf: estado!.substring(0, 2));
                        }
                      });
                    }),
              ),
            ),
            RawKeyboardListener(
              focusNode: FocusNode(),
              onKey: estado == null
                  ? null
                  : (estado!.substring(0, 2) == "BA" ||
                          estado!.substring(0, 2) == "TO")
                      ? (value) {
                          if (value is RawKeyDownEvent) {
                            RegExp digitRegExp = RegExp(r'\d');
                            bool isDigit(String s) => s.contains(digitRegExp);
                            if (value.logicalKey.keyLabel.toString() ==
                                "Backspace") {
                              if (count != 0) {
                                count--;
                              }
                            } else if (isDigit(
                                value.logicalKey.keyLabel.toString())) {
                              if (estado!.substring(0, 2) == "BA"
                                  ? count < 9
                                  : count < 11) {
                                count++;
                              }
                            }
                          }
                          if (estado!.substring(0, 2) == "BA") {
                            if (count != 9) {
                              maskFormatterInscE.updateMask(
                                  mask: "######-###",
                                  filter: {"#": RegExp(r'[0-9]')});
                            } else {
                              maskFormatterInscE.updateMask(
                                  mask: "#######-##",
                                  filter: {"#": RegExp(r'[0-9]')});
                            }
                          } else {
                            if (count != 11) {
                              maskFormatterInscE.updateMask(
                                  mask: "########-###",
                                  filter: {"#": RegExp(r'[0-9]')});
                            } else {
                              maskFormatterInscE.updateMask(
                                  mask: "##########-#",
                                  filter: {"#": RegExp(r'[0-9]')});
                            }
                          }
                        }
                      : null,
              child: TextField(
                controller: textControllers[4],
                inputFormatters: [maskFormatterInscE],
                decoration: InputDecoration(
                    label: const Text("Inscrição estadual"),
                    errorText: mensagemDeErro[4]),
                onChanged: (text) {
                  setState(() {
                    mensagemDeErro[4] = null;
                    print(count);
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[5],
              inputFormatters: [maskFormatterTelefone],
              decoration: InputDecoration(
                  label: const Text("Telefone"), errorText: mensagemDeErro[5]),
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
                  label: const Text("Ganho Mensal"),
                  errorText: mensagemDeErro[6]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[6] = null;
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
              controller: textControllers[7],
              decoration: InputDecoration(
                  label: const Text("Logradouro"),
                  errorText: mensagemDeErro[7]),
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
                  label: const Text("Numero"), errorText: mensagemDeErro[8]),
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
                  label: const Text("Bairro"), errorText: mensagemDeErro[9]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[9] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[10],
              decoration: InputDecoration(
                  label: const Text("Cidade"), errorText: mensagemDeErro[10]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[10] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[11],
              decoration: InputDecoration(
                  label: const Text("CEP"), errorText: mensagemDeErro[11]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[11] = null;
                });
              },
            ),
            const SizedBox(height: 15),
            TextField(
              controller: textControllers[12],
              decoration: InputDecoration(
                  label: const Text("Complemento"),
                  errorText: mensagemDeErro[12]),
              onChanged: (text) {
                setState(() {
                  mensagemDeErro[12] = null;
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
      }
    }
    return isPreenchido;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Home');
              },
              icon: const Icon(Icons.arrow_back)),
        ),
        body: Stack(
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Image.asset(
                  AppController.instance.background,
                  fit: BoxFit.cover,
                )),
            _body()
          ],
        ));
  }
}
