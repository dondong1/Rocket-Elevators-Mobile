import 'package:flutter/material.dart';
import 'package:rocket/elevators.dart';
import 'package:rocket/main.dart';

//Custom widgets

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  static String tag = 'elevators';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elevator Portal',
      home: Scaffold(
        appBar: AppBar(title: Text('Elevators'), actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
                onPressed: () {
        try{
          Navigator.popUntil(context, ModalRoute.withName('/'));
          // Navigator.popUntil(login_page, ModalRoute.withName('/'));
        }
        catch(_) {}
      },
          ),
          Image.asset("images/R2.png"),
        ]),
        body: Center(child: ElevatorListView()),
      ),
    );
  }
}
