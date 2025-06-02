import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';

// ignore: must_be_immutable
class Subjects extends StatefulWidget{
  final String token;
  final Function goto;
  Subjects(this.token, this.goto, {super.key});

  @override
  State<Subjects> createState() => _SubjectsState();
}

class _SubjectsState extends State<Subjects> {

  late Future<Map> subjectsFuture;

  Future<Map> getSubjects() async {
    final response = await http.get(Uri.parse('${Constants.API_ENDPOINT}student/subjects/'),headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
      Map body = jsonDecode(response.body) as Map;
      print(body);
     return body;
  }

  @override
  initState() {
    super.initState();
    subjectsFuture = getSubjects();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.headlineMedium!;

    return Scaffold(
      body: Card(
        child: ListView(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 32,),
                  Text("Materias", style: style),
                  SizedBox(height: 32,),
                  FutureBuilder(future: subjectsFuture, builder: (context, snapshot) { if (snapshot.hasData) { final items = snapshot.data?['subjects'];
                    return ListView.builder(
                      shrinkWrap: true, itemCount: items.length, itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                                child: 
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(item['title'], style: Theme.of(context).textTheme.headlineSmall,),
                                          ],
                                        ),
                                        SizedBox(height: 8,),
                                        Row(
                                          children: [
                                            Text("${snapshot.data?['stage']}${snapshot.data?['grade']}${snapshot.data?['parallel']}"),
                                          ],
                                        ),
                                        SizedBox(height: 16,),
                                        Row(
                                          children: [
                                            ElevatedButton(onPressed: () { widget.goto(2, pk: item['id'], cl: snapshot.data?['id']); }, child: Text("Asistencia")),
                                            ElevatedButton(onPressed: () { widget.goto(3, pk: item['id'], cl: snapshot.data?['id']); }, child: Text("Notas")),
                                            ElevatedButton(onPressed: () { widget.goto(4, pk: item['id'], cl: snapshot.data?['id']); }, child: Text("Participaciones")),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                    });
                  } else {return Text('no data');}}
                  ),
                  ],
                ),
            ),
            ],
          ),
        ),
      );
  }
}