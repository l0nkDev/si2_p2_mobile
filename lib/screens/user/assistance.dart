import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';

// ignore: must_be_immutable
class Assistance extends StatefulWidget{
  final String token;
  final Function goto;
  final int pk;
  final int _class;
  const Assistance(this.token, this.goto, this.pk, this._class, {super.key});

  @override
  State<Assistance> createState() => _AssistanceState();
}

class _AssistanceState extends State<Assistance> {
  
  late Future<Map> assistanceFuture;
  late Future<Map> todayFuture;
  late Future<List> sessionsFuture;

  Future<Map> getAssistances() async {
    final response = await http.get(Uri.parse('${Constants.API_ENDPOINT}student/subjects/${widget.pk}/${widget._class}/assistance/'),headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
      Map body = jsonDecode(response.body) as Map;
      final List sess = await getSessions();
      for (Map s in sess) {
        bool found = false;
        for (Map s2 in body['assistances']) {
          if (s['date'] == s2['date']) found = true;
        }
        if (!found) body['assistances'].add({"date": s['date'], "status": "missed"});
      }
      print(body);
     return body;
  }

  Future<Map> getToday() async {
    final response = await http.get(Uri.parse('${Constants.API_ENDPOINT}student/subjects/${widget.pk}/${widget._class}/assistance/sessions/today/'),headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
     final Map body = jsonDecode(response.body) as Map;
     return body;
  }

  Future<List> getSessions() async {
    final response = await http.get(Uri.parse('${Constants.API_ENDPOINT}student/subjects/${widget.pk}/${widget._class}/assistance/sessions/'),headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
     final List body = jsonDecode(response.body) as List;
     return body;
  }

  void sendAssistance() async {
    await http.post(Uri.parse('${Constants.API_ENDPOINT}student/subjects/${widget.pk}/${widget._class}/assistance/sessions/today/'),
    headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
    assistanceFuture = getAssistances();
    todayFuture = getToday();
    sessionsFuture = getSessions();
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    assistanceFuture = getAssistances();
    todayFuture = getToday();
    sessionsFuture = getSessions();
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
          Text("Historial de asistencias", style: style),
          SizedBox(height: 32,),
          FutureBuilder (future: assistanceFuture, builder: (context, snapshot) { if (snapshot.hasData) { final items = snapshot.data;
            if (items == null) return Text('item is null');
            print(items);
              return Column(
                children: [
                  FutureBuilder(future: todayFuture, builder: (context, today) { if (today.hasData) {
                    if (today.data == null) { return ElevatedButton(onPressed: null, child: Text('Marcar')); }
                    else if (today.data?['detail'] == null) {
                      if (today.data?['status'] == 'E') {return ElevatedButton(onPressed: null, child: Text('Marcar'));}
                      else {return ElevatedButton(onPressed: () {sendAssistance();}, child: Text('Marcar'));}
                    }
                    }
                    return (ElevatedButton(onPressed: null, child: Text('Marcar')));
                  }),
                  SizedBox(height: 8),
                  Container(alignment: Alignment.center, height: 32, width: 256, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("${items['rude']} | ${items['lname']} ${items['name']}")),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("Fecha")),
                    Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("Estado")),
                  ],),
                  ListView.builder(shrinkWrap: true, itemCount: items['assistances'].length, itemBuilder: (context, index) {
                    final item = items['assistances'][index];
                    return Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text(item['date'])),
                        Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text(item['status']))
                      ],
                    );
                  }),
                ],
              );
            } else {return Text('no data');}}
          ),
        ],
      ),
    );
  }
}