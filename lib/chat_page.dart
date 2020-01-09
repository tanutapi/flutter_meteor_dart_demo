import 'package:dart_meteor/dart_meteor.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/main.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _textEditingControllerMessage =
      TextEditingController();
  SubscriptionHandler _sub;
  Map<String, dynamic> _users;

  @override
  void initState() {
    super.initState();
    meteor.prepareCollection('messages');
    _sub = meteor.subscribe('messages', []);

    meteor.collections['users'].listen((data) {
      print('abc');
      print(data);
      _users = data;
    });
  }

  @override
  void dispose() {
    _textEditingControllerMessage.dispose();
    if (_sub != null) {
      _sub.stop();
      _sub = null;
    }
    super.dispose();
  }

  void _sendMessage() {
    var msg = _textEditingControllerMessage.text;
    meteor.call('sendMessage', [msg]).then((res) {
      _textEditingControllerMessage.text = '';
    }).catchError((_) {});
  }

  void _clearAllMessage() async {
    if (await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Do you want to delete all chat message?'),
            actions: <Widget>[
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        })) {
      meteor.call('clearAllMessages', []).catchError((_) {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentUsername = 'unknown';
    if (meteor.userCurrentValue() != null &&
        meteor.userCurrentValue()['username'] != null) {
      currentUsername =
          '${meteor.userCurrentValue()['profile']['name']} ${meteor.userCurrentValue()['profile']['surname']}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('A Simple Meteor Chat'),
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            meteor.logout();
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: _clearAllMessage,
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              'Welcome $currentUsername',
              textScaleFactor: 2.0,
            ),
            Expanded(
              child: StreamBuilder(
                stream: meteor.collections['messages'],
                builder:
                    (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
                  if (snapshot.hasData) {
                    List<dynamic> messages = snapshot.data.values.toList();
                    messages.sort((x, y) {
                      return x['createdAt']['\$date']
                          .compareTo(y['createdAt']['\$date']);
                    });
                    if (messages.length > 0) {
                      return ListView.builder(
                        itemCount: messages.length,
                        itemBuilder: (context, idx) {
                          String from = messages[idx]['from'];
                          if (_users != null) {
                            from = _users[messages[idx]['from']]['username'];
                          }
                          return ListTile(
                            leading: Text(from),
                            title: Text(messages[idx]['msg']),
                          );
                        },
                      );
                    }
                  }
                  return ListTile(
                    title: Text('No chat message... Please send one.'),
                  );
                },
              ),
            ),
            SafeArea(
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextFormField(
                      controller: _textEditingControllerMessage,
                    ),
                  ),
                  RaisedButton(
                    child: Text('Send'),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
