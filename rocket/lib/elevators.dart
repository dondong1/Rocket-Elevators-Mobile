import 'dart:async';
import 'dart:convert';
import 'package:rocket/login_page.dart';
import 'main.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

//Creates an Elevator Object Defines the properties of the elevator.
class Elevator {
  final String status;
  final String model;
  final int id;

  Elevator({this.status, this.model, this.id}); //Elevator Constructor

  factory Elevator.fromJson(Map<String, dynamic> json) {
    //Parse the infos as Json String
    return Elevator(
        status: json['status'], model: json['model'], id: json['id']);
  }
}

class ElevatorListView extends StatelessWidget {
  //Creates the listview
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Elevator>>(
      future: _fetchElevators(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Elevator> data = snapshot.data;
          return _elevatorsListView(data);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }
        return CircularProgressIndicator();
      },
    );
  }

  Future<List<Elevator>> _fetchElevators() async {
    //Fetch the data from the api

    // ignore: non_constant_identifier_names
    final ElevatorListAPIUrl = 'https://donnguyen.herokuapp.com/api/Elevators';
    final response = await http.get(ElevatorListAPIUrl);

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse
          .map((elevator) => new Elevator.fromJson(elevator))
          .toList();
    } else {
      throw Exception('Failed to load Elevators from API');
    }
  }

  ListView _elevatorsListView(data) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return _tile(data[index].status, data[index].id.toString(),
              Icons.watch, context, data, index); //Tiles Constructor
        });
  }

  ListTile _tile(
          String title, String subtitle, IconData icon, context, data, index) =>
      ListTile(
        //The tiles in person, don't be shy !
        title: Text("Status: " + title,
            style: TextStyle(
              // if (Status != "Active")
              //  {
              //   font Color: red;
              // } else {
              //   text Color: blue;
              // },
              fontWeight: FontWeight.w500,
              fontSize: 20,
            )),
        subtitle: Text("Elevator # " + subtitle),
        leading: Icon(
          icon,
          color: Colors.red[400],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailScreen(elevator: data[index]),
            ),
          );
        },
      );
}

TextEditingController _statusController = TextEditingController();

class DetailScreen extends StatelessWidget {
  // Declare a field that holds the Todo.
  final Elevator elevator;

  // In the constructor, require a Todo.
  DetailScreen({Key key, @required this.elevator}) : super(key: key);

  Future _changeStatus(Elevator elevator) async {
    //Fetch the data from the api
    // ignore: non_constant_identifier_names
    var text = _statusController.text;
    var estat = '{"status": "$text"}';
    var url = 'https://donnguyen.herokuapp.com/api/Elevators' +
        elevator.id.toString();
    var response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: estat,
    );
    print(_statusController.text);
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');
    print(url);

    //print(await http.read('https://example.com/foobar.txt'));
    return "sucess";
  }

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
          title: Text("Elevator # " + elevator.id.toString()),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Logout',
              onPressed: () {
                try {
                  Navigator.popUntil(context, ModalRoute.withName('/'));
                  // Navigator.popUntil(login_page, ModalRoute.withName('/'));
                } catch (_) {}
              },
            ),
            Image.asset("images/R2.png"),
          ]),
      body: Center(
          child: Center(
        child: TextFormField(
            controller: _statusController,
            decoration: InputDecoration(
              labelText: 'Enter The Desired Status',
              labelStyle: TextStyle(
                fontSize: 30.5,
              ),
            )),
      )),
      floatingActionButton: FloatingActionButton(
          onPressed: () async => [
                await _changeStatus(elevator),
                await print(elevator.status),
                await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                          content: Text("The elevator # " +
                              elevator.id.toString() +
                              " has been set to " +
                              _statusController.text));
                    })
              ]),
    );
  }
}
