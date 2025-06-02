import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class Grades extends StatefulWidget{
  final String token;
  final Function goto;
  final int pk;
  final int _class;
  const Grades(this.token, this.goto, this.pk, this._class, {super.key});

  @override
  State<Grades> createState() => _AssistanceState();
}

class _AssistanceState extends State<Grades> {
  
  late Future<Map> scoresFuture;
  late Future<List> targetsFuture;

  int getScore(Map student,  int id) {
    for (Map score in student['scores']) {
      if (score['target'] == id) return score['score']; }
    return 0;
  }

  double getAverage(List trimester, Map student) {
    double sum = 0;
    for (Map t in trimester) {
        print('calculando');
      for (Map s in student['scores']) {
        if (t['id'] == s['target']) sum = sum + s['score'];
      }
    }
    if (sum == 0) {
      return 0;
    }
    return sum/trimester.length;
  }

  Future<Map> getScores() async {
    final response = await http.get(Uri.parse('${Constants.API_ENDPOINT}student/subjects/${widget.pk}/${widget._class}/scores/'),headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
      Map body = jsonDecode(response.body) as Map;
      final List targ = await getTargets();
      List nscores = [];
      List t1 = [];
      List t2 = [];
      List t3 = [];
      for (Map t in targ) {
        if (t['trimester'] == 1) t1.add(t);
        if (t['trimester'] == 2) t2.add(t);
        if (t['trimester'] == 3) t3.add(t);
      }
      for (Map t in t1) {
        nscores.add({"title": t['title'], "score": getScore(body, t['id'])});
      }
      nscores.add({"title": "1er Trimestre", "score": getAverage(t1, body)});
      for (Map t in t2) {
        nscores.add({"title": t['title'], "score": getScore(body, t['id'])});
      }
      nscores.add({"title": "2do Trimestre", "score": getAverage(t2, body)});
      for (Map t in t3) {
        nscores.add({"title": t['title'], "score": getScore(body, t['id'])});
      }
      nscores.add({"title": "3er Trimestre", "score": getAverage(t3, body)});
      body['scores'] = nscores;
     return body;
  }

  Future<List> getTargets() async {
    final response = await http.get(Uri.parse('${Constants.API_ENDPOINT}student/subjects/${widget.pk}/${widget._class}/scores/targets/'),headers: {HttpHeaders.authorizationHeader: "Bearer ${widget.token}"});
     final List body = jsonDecode(response.body) as List;
     return body;
  }

  String formatScore(double v) {
    NumberFormat formatter = NumberFormat();
    formatter.minimumFractionDigits = 0;
    formatter.maximumFractionDigits = 2;
    return formatter.format(v);
  }

  @override
  initState() {
    super.initState();
    scoresFuture = getScores();
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
          Text("Historial de notas", style: style),
          SizedBox(height: 32,),
          FutureBuilder (future: scoresFuture, builder: (context, snapshot) { if (snapshot.hasData) { final items = snapshot.data;
            if (items == null) return Text('item is null');
            print(items);
              return Column(
                children: [
                  Container(alignment: Alignment.center, height: 32, width: 256, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("${items['rude']} | ${items['lname']} ${items['name']}")),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("Fecha")),
                    Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("Estado")),
                  ],),
                  ListView.builder(shrinkWrap: true, itemCount: items['scores'].length, itemBuilder: (context, index) {
                    final item = items['scores'][index];
                    return Row( mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text("${item['title']}")),
                        Container(alignment: Alignment.center, height: 32, width: 128, decoration: BoxDecoration(border: Border.all(color: Colors.black)), child: Text(formatScore((item['score'].toDouble())))),
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