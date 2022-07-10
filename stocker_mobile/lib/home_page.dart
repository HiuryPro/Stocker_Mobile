import 'package:flutter/material.dart';
import 'app_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  int count = 0;
  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
         title: const Text('Dandjaro')
      ),
      body:  Center(
          child: Switch(
                    value: AppController.instance.isDarkTheme,
                    onChanged: (value){
                      setState(() {
                         AppController.instance.changeTheme();
                      });
                    
                    },
                  )
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            count++;
          });
        },  
      ),
    
    );
  }
}
