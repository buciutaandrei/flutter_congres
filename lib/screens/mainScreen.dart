import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import './splashScreen.dart';
import '../providers/auth.dart';
import '../screens/authenticationScreen.dart';
import 'fullProgramScreen.dart';

final _push = FirebaseMessaging();

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool _newNotification = false;
  String _token;

  @override
  void initState() {
    super.initState();
    _push.subscribeToTopic('all');
    _push.configure(
      onMessage: (Map<String, dynamic> message) async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(message['notification']['title']),
            content: Text(message['notification']['body']),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'OK',
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('onLaunch: $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('onResume: $message');
      },
    );

    _push.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, badge: true, alert: true),
    );
    _push.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print(settings);
    });

    _push.getToken().then((String token) {
      assert(token != null);
      setState(() {
        _token = token;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, _) => auth.isAuth
          ? FullProgramScreen()
          : FutureBuilder(
              future: auth.tryAutoLogin(),
              builder: (context, snapshot) {
                return snapshot.connectionState == ConnectionState.waiting
                    ? SplashScreen()
                    : snapshot.data
                        ? FullProgramScreen()
                        : AuthenticationScreen();
              }),
    );
  }
}
