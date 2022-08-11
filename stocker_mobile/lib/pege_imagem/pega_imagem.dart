import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:universal_html/html.dart';

class TesteImagem extends StatefulWidget {
  const TesteImagem({Key? key}) : super(key: key);

  @override
  State<TesteImagem> createState() => _TesteImagemState();
}

class _TesteImagemState extends State<TesteImagem> {
  bool isImageGetted = false;
  FilePickerResult? pickedFile;
  var logoBase64;

  chooseImage() async {
    pickedFile = await FilePicker.platform.pickFiles();
    if (pickedFile != null) {
      try {
        setState(() {
          logoBase64 = pickedFile!.files.first.bytes;
          isImageGetted = true;
        });
      } catch (err) {
        print(err);
      }
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? logoBase64;
    return Scaffold(
        body: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  const Center(
                    child: Text("Pega Imagem"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      await chooseImage();
                    },
                    child: const Text("Pega arquivo da imagem"),
                  ),
                  const SizedBox(height: 20),
                  if (isImageGetted) Image.memory(logoBase64!),
                  if (!isImageGetted) const Text("Imagem não veio"),
                ],
              ),
            )));
  }
}
