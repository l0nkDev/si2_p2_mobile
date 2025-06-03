import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';

// ignore: must_be_immutable
class Participation extends StatefulWidget{
  final String token;
  final Function goto;
  final int pk;
  final int _class;
  const Participation(this.token, this.goto, this.pk, this._class, {super.key});

  @override
  State<Participation> createState() => _AssistanceState();
}

class _AssistanceState extends State<Participation> {
  
  late Future<Map> participationFuture;
  late Future<Map> todayFuture;
  late Future<List> sessionsFuture;

  Future<Map> getParticipations() async {
    final response = await http.get(Uri.parse('${Constants.API_ENDPOINT}student/subjects/${widget.pk}/${widget._class}/participation/'),headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
      Map body = jsonDecode(response.body) as Map;
     return body;
  }

  @override
  initState() {
    super.initState();
    participationFuture = getParticipations();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context); 
    final style = theme.textTheme.headlineMedium!;
    return Scaffold(
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 32,),
          Text("Historial de participaciones", style: style),
          SizedBox(height: 32,),
          Expanded(
            child: FutureBuilder (future: participationFuture, builder: (context, snapshot) { if (snapshot.hasData) { final items = snapshot.data;
              if (items == null) return Text('item is null');
              print(items);
                return Column(
                  children: [
                    Container(alignment: Alignment.center, height: 32, width: 384, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("${items['rude']} | ${items['lname']} ${items['name']}")),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("Fecha")),
                      Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("Descripción")),
                      Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("Nota")),
                    ],),
                    Expanded(
                      child: ListView.builder(shrinkWrap: true, itemCount: items['participations'].length, itemBuilder: (context, index) {
                        final item = items['participations'][index];
                        return Row( mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(alignment: Alignment.center, height: 64, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text(item['date'])),
                            Container(alignment: Alignment.center, height: 64, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text(item['description'])),
                            Container(alignment: Alignment.center, height: 64, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("${item['score']}")),
                          ],
                        );
                      }),
                    ),
                  ],
                );
              } else {return Text('no data');}}
            ),
          ),
        ],
      ),
    );
  }
}