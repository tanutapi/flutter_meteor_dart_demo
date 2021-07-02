import 'package:dart_meteor/dart_meteor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/chat_page.dart';
import 'package:flutter_app/connecting_page.dart';
import 'package:flutter_app/login_page.dart';

MeteorClient meteor = MeteorClient.connect(url: 'http://localhost:3000');

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder<DdpConnectionStatus>(
          stream: meteor.status(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.connected) {
                return StreamBuilder<Map<String, dynamic>>(
                  stream: meteor.user(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ChatPage();
                    }
                    return LoginPage();
                  },
                );
              }
              return ConnectingPage();
            }
            return Container();
          }),
    );
  }
}
