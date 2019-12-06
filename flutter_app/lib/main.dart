import 'dart:async';
import 'package:http/http.dart' as http;


import 'dart:convert';
import 'package:flutter/material.dart';

const UrlJson = "https://api.myjson.com/bins/1dswv4";

class API {
  static Future getEleves() {
    var url = UrlJson;
    return http.get(url);
  }
}




void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  build(context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Présence Groupe 1 B2',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  createState() => _HomeScreenState();
}


class _HomeScreenState extends State {
  var eleves = List<Eleve>();
  var elevesAbsent = List<Eleve>();

  _getEleves() {
    API.getEleves().then((response) {
      setState(() {
        Iterable list = json.decode(response.body);
        eleves = list.map((model) => Eleve.fromJson(model)).toList();
      });
    });
  }

  initState() {
    super.initState();
    _getEleves();
  }

  dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Présence Groupe 1 B2"),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.list),
                onPressed: () {_pushAbsentLateScreen(elevesAbsent);}
            )
          ],
        ),
        body: ListView.builder(
          itemCount: eleves.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(eleves[index].nom + " " + eleves[index].prenom),
              trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(
                          eleves[index].absent ? Icons.airline_seat_individual_suite : Icons
                              .accessibility,
                          color: eleves[index].retard ? Colors.red : Colors
                              .blue),
                      onPressed: () {
                        setState(() {
                          if (eleves[index].retard == true) {
                            eleves[index].retard = false;
                          } else {
                            eleves[index].retard = true;
                          }
                        });
                      },
                    ),

                  ]),
            );
          },
        ));
  }

  void _pushAbsentLateScreen(usersAbsent) {
    Navigator.push(context,
      new MaterialPageRoute(builder: (context) {
        return new AbsentLateScreen(elevesAbsent, eleves);
      }),
    );
  }
}


class Eleve {
  String nom;
  String prenom;
  bool absent;
  bool retard;

  Map toJson() {
    return {'nom': nom, 'prenom': prenom, 'absent': absent, 'retard': retard};
  }


  Eleve.fromJson(Map json)
      : nom = json['nom'],
        prenom = json['prenom'],
        absent = false,
        retard = false;


  Eleve(String nom, String prenom, bool absent, bool retard) {
    this.nom = nom;
    this.prenom = prenom;
    this.absent = absent;
    this.retard = retard;
  }


}

class AbsentLateScreen extends StatelessWidget {
  final elevesAbsent;
  final eleves;
  AbsentLateScreen(this.elevesAbsent, this.eleves);


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Absences')),
      body: ListView.builder(
        itemCount: elevesAbsent.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(elevesAbsent[index].nom + " " + elevesAbsent[index].prenom),
            trailing: Icon(Icons.cancel, color: Colors.red),
            onTap: () {      // Add 9 lines from here...
              eleves[index].absent = false;
              elevesAbsent.remove(elevesAbsent[index]);
            },
          );
        },
      ),
    );
  }
}