import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';
import 'package:si2_p2_mobile/models/user.dart';
import '../../components/labeledInput.dart';

// ignore: must_be_immutable
class Profile extends StatelessWidget{
  final String token;
  Profile(this.token, {super.key});

    TextEditingController rude = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController lname = TextEditingController();
    TextEditingController _class = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.headlineMedium!;
    rude.value = TextEditingValue(text: "225000001");
    name.value = TextEditingValue(text: "Joaquin");
    lname.value = TextEditingValue(text: "Chumacero");
    _class.value = TextEditingValue(text: "P1A");
    return Scaffold(
      body: Card(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 32,),
              Text("Perfil de estudiante", style: style),
              SizedBox(height: 32,),
              LabeledInput(label: "RUDE", controller: rude,),
              LabeledInput(label: "Nombre", controller: name),
              LabeledInput(label: "Apellido", controller: lname),
              LabeledInput(label: "Curso", controller: _class),
            ],
          ),
        ),
      ),
    );
  }
}