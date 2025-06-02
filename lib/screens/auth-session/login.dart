import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';
import 'package:si2_p2_mobile/firebase_api.dart';

class Login extends StatelessWidget{
  final Function setToken;
  final Function goto;
  const Login(this.setToken, this.goto, {super.key});



  Future<void> sendLogin(String login, String password, BuildContext context) async {
    Map<String,String> headers = {
      'Content-type' : 'application/json', 
      'Accept': 'application/json',
    };
    
      var response = await http.post(Uri.parse('${Constants.API_ENDPOINT}auth/login/'), 
      headers: headers,
      body:
      '''
      {
          "login": "$login",
          "password": "$password",
          "fcm": "${await FirebaseApi().initNotifications()}"
      }
      '''
    );
    if (response.statusCode == 200) {
      print(response.body);
      var decodedResponse = jsonDecode(utf8.decode(response.bodyBytes)) as Map;
      if (decodedResponse['role'] != 'S') {
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Inicia sesión como estudiante por favor.")));
      return;
      }
      ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Sesión iniciada correctamente.")));
      setToken(decodedResponse["access_token"]);
      goto(0);
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No se pudo iniciar sesión.")),
      );
    }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.headlineMedium!;

    TextEditingController login = TextEditingController();
    TextEditingController passwd = TextEditingController();

    return Scaffold(
      body: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Inicio de sesión", style: style),
              SizedBox(height: 32,),
              TextField(decoration: InputDecoration(border: OutlineInputBorder(), label: Text("Login")), controller: login,),
              SizedBox(height: 32,),
              TextField(decoration: InputDecoration(border: OutlineInputBorder(), label: Text("Contraseña")), controller: passwd,),
              SizedBox(height: 32,),
              FilledButton(
                child: Text("Iniciar sesión"),
                onPressed: () {
                  sendLogin(login.value.text, passwd.value.text, context);
                }
              ),
            ],
          ),
        ),
      ),
      );
  }
}