import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';
import 'package:si2_p2_mobile/models/user.dart';
import '../../components/labeledInput.dart';

// ignore: must_be_immutable
class Subjects extends StatelessWidget{
  final String token;
  final Function goto;
  Subjects(this.token, this.goto, {super.key});

    TextEditingController email = TextEditingController();
    TextEditingController passwd = TextEditingController();
    TextEditingController role = TextEditingController();
    TextEditingController name = TextEditingController();
    TextEditingController lname = TextEditingController();
    TextEditingController country = TextEditingController();
    TextEditingController state = TextEditingController();
    TextEditingController address = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.headlineMedium!;

    return Scaffold(
      body: Card(
        child: ListView(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 32,),
                Text("Materias", style: style),
                SizedBox(height: 32,),
                Card(
                  child: 
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Text("Matematicas", style: Theme.of(context).textTheme.headlineSmall,),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            children: [
                              Text("P1A",),
                            ],
                          ),
                          SizedBox(height: 16,),
                          Row(
                            children: [
                              ElevatedButton(onPressed: () { goto(2); }, child: Text("Asistencia")),
                              ElevatedButton(onPressed: () { goto(3); }, child: Text("Notas")),
                              ElevatedButton(onPressed: () { goto(4); }, child: Text("Participaciones")),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      );
  }
}