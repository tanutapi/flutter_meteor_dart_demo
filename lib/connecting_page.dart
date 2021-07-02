import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class ConnectingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
              SizedBox(
                height: 12.0,
              ),
              Text('Connecting to the server...'),
              SizedBox(
                height: 12.0,
              ),
              ElevatedButton(
                child: Text('Retry to connect now!'),
                onPressed: () {
                  meteor.reconnect();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
