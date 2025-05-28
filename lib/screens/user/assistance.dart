import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:si2_p2_mobile/constants.dart';
import 'package:si2_p2_mobile/models/user.dart';
import '../../components/labeledInput.dart';

// ignore: must_be_immutable
class Assistance extends StatelessWidget{
  final String token;
  final Function goto;
  Assistance(this.token, this.goto, {super.key});

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
                Text("Historial de asistencias", style: style),
                SizedBox(height: 32,),
                Card(
                  child: DataTable(
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Expanded(child: Text('Fecha', style: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                      DataColumn(
                        label: Expanded(child: Text('Estado', style: TextStyle(fontStyle: FontStyle.italic))),
                      ),
                    ],
                    rows: const <DataRow>[
                      DataRow(
                        cells: <DataCell>[
                          DataCell(Text('2025-05-27')),
                          DataCell(Text('present')),
                        ],
                      ),
                    ],
                  ),
                ),
                ],
              ),
            ],
          ),
        ),
      );
  }
}