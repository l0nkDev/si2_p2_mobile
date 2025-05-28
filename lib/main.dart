import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:si2_p2_mobile/firebase_api.dart';
import 'package:si2_p2_mobile/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:si2_p2_mobile/screens/user/assistance.dart';
import 'package:si2_p2_mobile/screens/user/grades.dart';
import 'package:si2_p2_mobile/screens/user/participation.dart';
import 'package:si2_p2_mobile/screens/user/profile.dart';
import 'package:si2_p2_mobile/screens/user/subjects.dart';
import 'screens/auth-session/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'SI2 mobile',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

var selectedIndex = 1;
var product = 0;
bool isLogged = false;
late SharedPreferences prefs;
String token = "";
String refreshToken = "";

  void setToken(String newToken) {
    token = newToken;
    isLogged = true;
    prefs.setString('token', token);
  }

  void goto(int n, {int y = 0}) { setState(() { 
    print("y: $y | n: $n");
    product = y;
    selectedIndex = n; 
  }); }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

  Future<void> initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token') ?? '';
    if (token != '') {isLogged = true;}
    setState(() {});
  }

  logout() async {
    await http.post(Uri.http("l0nk5erver.duckdns.org:5000", 'auth/logout'), 
      headers: {HttpHeaders.authorizationHeader: "Bearer $token", HttpHeaders.contentTypeHeader: 'application/json'},
      body: 
      '''
        {
          "fcm": "${await FirebaseApi().initNotifications()}"
        }
    '''
    );
    token = ""; 
    isLogged = false;
    prefs.setString('token', '');
    selectedIndex = 0; 
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
  Widget page;
  switch (selectedIndex) {
    case 0:
      page = Subjects(token, goto);
    case 1:
      page = Login(setToken, goto);
    case 2:
      page = Assistance(token, goto);
    case 3:
      page = Grades(token, goto);
    case 4:
      page = Participation(token, goto);
    case 5:
      page = Login(setToken, goto);
    case 6:
      page = Profile(token);
  default:
    throw UnimplementedError('no widget for $selectedIndex');
}
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          appBar: AppBar(title: const Text('Parcial 2')),
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.only(top: 40),
              children: [
              Column(
                children: [
                  InkWell(
                    onTap: () {setState(() {
                      if (isLogged) {
                        logout();
                      } else { selectedIndex = 1; }
                      Navigator.pop(context);
                      });},
                    child: Row(
                      children: [
                        SizedBox(height: 64, width: 10,),
                        Icon(isLogged ? Icons.logout : Icons.login),
                        SizedBox(height: 64, width: 10,),
                        Text(isLogged ? "Cerrar sesion" : "Iniciar Sesion"),
                      ],
                    ),
                  ),
                  if (isLogged)
                    InkWell(
                      onTap: () {setState(() {selectedIndex = 0; Navigator.pop(context);});},
                      child: Row(
                        children: [
                          SizedBox(height: 64, width: 10,),
                          Icon(Icons.list_alt),
                          SizedBox(height: 64, width: 10,),
                          Text("Materias"),
                        ],
                      ),
                    ),
                  if (isLogged)
                    InkWell(
                      onTap: () {setState(() {selectedIndex = 6; Navigator.pop(context);});},
                      child: Row(
                        children: [
                          SizedBox(height: 64, width: 10,),
                          Icon(Icons.person),
                          SizedBox(height: 64, width: 10,),
                          Text("Perfil de estudiante"),
                        ],
                      ),
                    ),
                ],
              )
              ],
            ),
          ),
          body: Row(
            children: [
              SafeArea(child: Text("")),
              Expanded(
                child: Container(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: page,
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}

