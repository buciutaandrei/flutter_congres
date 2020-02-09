import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SendFCMScreen extends StatelessWidget {
  static const routeName = '/sendFCMScreen';

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();

  Future<void> _sendMessage({String title, String body}) async {
    final String url = 'https://fcm.googleapis.com/fcm/send';
    final String key =
        'key=AAAAld64RiA:APA91bEuPAlns_tsFjwT3j420L2b2R_Lnk-Ia5TwiO9JBdOqIQET8Rw64wnXmpJG3Gxw38ctkbLPX6oSoQTmv9BlVRWbMy4h6sUJgDkwPfUw_T-yiPvR5Jfos2QtbHIo0WEKEFFYGsWv';
    http.post(url,
        headers: {'Content-Type': 'application/json', 'Authorization': key},
        body: json.encode({
          "notification": {"body": body, "title": title},
          "to": "/topics/all"
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Push messages'),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                    icon: Icon(
                      Icons.title,
                    ),
                    labelText: 'Title'),
                controller: _titleController,
              ),
              TextFormField(
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.short_text,
                  ),
                  labelText: 'Message',
                ),
                minLines: 3,
                maxLines: 5,
                controller: _bodyController,
              ),
              SizedBox(
                height: 16,
              ),
              RaisedButton(
                child: Text(
                  'Push message',
                ),
                onPressed: () => _sendMessage(
                    title: _titleController.text, body: _bodyController.text),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
