import 'package:dart_meteor/dart_meteor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _username = '';
  String _password = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              onChanged: (str) {
                setState(() {
                  _username = str;
                });
              },
              decoration: InputDecoration(
                labelText: 'Username',
              ),
            ),
            TextFormField(
              onChanged: (str) {
                setState(() {
                  _password = str;
                });
              },
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: ElevatedButton(
                child: Text('Login'),
                onPressed: (_username.length > 0 && _password.length > 0)
                    ? () {
                        meteor
                            .loginWithPassword(_username, _password)
                            .catchError((err) {
                          if (err is MeteorError) {
                            print(err);
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Error'),
                                    content: Text(err.details ??
                                        "Error with no details."),
                                    actions: <Widget>[
                                      TextButton(
                                        child: Text('Dismiss'),
                                        onPressed: () {
                                          Navigator.of(context).pop(0);
                                        },
                                      ),
                                    ],
                                  );
                                });
                          }
                        });
                      }
                    : null,
              ),
            ),
            Text('User accounts:'),
            Text('user1 / password1'),
            Text('or'),
            Text('user2 / password2'),
          ],
        ),
      ),
    );
  }
}
