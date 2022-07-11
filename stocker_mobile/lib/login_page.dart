import 'package:flutter/material.dart';
import 'package:stocker_mobile/home_page.dart';

import 'db.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  var teste = Dados();
  dynamic listaU;
  dynamic listaS;

  @override
  void initState() {
    // TODO: implement initState
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



  @override
  Widget build(BuildContext context) {
    return Material(
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
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
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                        border: OutlineInputBorder(),
                      )
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                   ElevatedButton(
                    onPressed: () {
                      bool teste = false;
                      for(int i = 0; i < listaU.length; i++){
                        if(usuario == listaU[i] && senha == listaS[i]){
                          teste = true;
                        }
                      }
                      if(teste){
                        print("Login feito com sucesso");
                        Navigator.of(context).pushNamed('/homepage');
                      }else{
                        print('Usuário/senha incorretos');
                      }
                    }, child: const Text('Entrar'))
                  ],
                )
            )   
      )
    );
    
  }
}