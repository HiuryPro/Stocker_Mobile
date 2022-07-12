import 'package:flutter/material.dart';

import 'db.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final fieldText = TextEditingController();
  final fieldText2 = TextEditingController();

  var teste = Dados();
  
  dynamic listaU;
  dynamic listaS;

  @override
  void initState() {
    super.initState();
    teste.pegaUsuario().then((usuario){
      setState(() {
       listaU = usuario;
      });
    });
     teste.pegaSenha().then((senha){
      setState(() {
       listaS = senha;
      });
    });
  
    
  }
  String usuario = '';
  String senha = '';

  void clearText() {
    fieldText.clear();
    fieldText2.clear();
  }


  Widget _body(){
    return SizedBox(
        width: double.infinity,
        height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Theme(
              data: ThemeData(
                  primaryColor: Colors.black,
                  primaryColorDark: Colors.black,
                ),
              child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:[
                      SizedBox(
                        width: 400,
                        child: Image.asset('images/Stocker_blue_transp.png')
                        ),
                      const SizedBox(
                        height: 15,
                      ),
                    TextField(
                        onChanged: (text) {
                          usuario = text;
                        },
                        controller: fieldText,
                          decoration: const InputDecoration(
                          labelText: 'Usuário',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextField(
                        onChanged: (text) {
                          senha = text;
                        },
                        controller: fieldText2,
                        decoration: const InputDecoration(
                          labelText: 'Senha',
                          border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.red
                          )
                          ),
                          
                        )
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ElevatedButton(
                      onPressed: () {
                        bool autoriza = false;
                        for(int i = 0; i < listaU.length; i++){
                            if(usuario == listaU[i] && senha == listaS[i]){
                              autoriza = true;
                            }
                        }

                        if(autoriza){
                          print("Login feito com sucesso!");
                          Navigator.of(context).pushNamed("/homepage");
                        }else{
                          print("Usuário/senha incorretos");
                        }
                        clearText();
                      }, 
                      child: const Text('Entrar'))
                    ],
                  ),
            )
            )   
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('images/backstocker.jpg',fit: BoxFit.cover)
            ),
          _body()
        ]
       
        )
    );
    
  }
}