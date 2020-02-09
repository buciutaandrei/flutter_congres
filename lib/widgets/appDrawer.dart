import 'package:congres_app/providers/appState.dart';
import 'package:congres_app/screens/sendFCMScreen.dart';

import '../providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/customisedScreen.dart';
import '../screens/fullProgramScreen.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  _showModal(BuildContext context) {
    final _appState = Provider.of<AppState>(context, listen: false);
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ListTile(
              //isThreeLine: true,
              leading: Icon(Icons.palette),
              title: Text('Select Theme Mode'),
              subtitle: Text(_appState.themeModeName),
              trailing: PopupMenuButton(
                  icon: Icon(Icons.arrow_drop_down, size: 32),
                  onSelected: (value) {
                    _appState.updateTheme(value);
                  },
                  itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                            child: Text('Auto'), value: ThemeMode.system),
                        PopupMenuItem(
                            child: Text('Dark Theme'), value: ThemeMode.dark),
                        PopupMenuItem(
                            child: Text('Light Theme'), value: ThemeMode.light),
                      ]),
            ),
            ListTile(
              title: Text('Sign out'),
              leading: Icon(Icons.power_settings_new),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/');
                Provider.of<Auth>(context, listen: false).signOut();
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _isAdmin = Provider.of<Auth>(context, listen: false).isAdmin;

    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child: DrawerHeader(
              margin: EdgeInsets.all(0),
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Text('Menu',
                        style: TextStyle(fontSize: 32, color: Colors.white)),
                    IconButton(
                      icon: Icon(
                        Icons.settings,
                        size: 32,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        _showModal(context);
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(
                          'Main program',
                        ),
                        leading: Icon(
                          Icons.calendar_today,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();

                          Navigator.of(context).pushReplacementNamed(
                              FullProgramScreen.routeName);
                        },
                      ),
                      ListTile(
                        title: Text(
                          'My program',
                        ),
                        leading: Icon(
                          Icons.schedule,
                        ),
                        onTap: () {
                          Navigator.of(context).pop();

                          Navigator.of(context)
                              .pushReplacementNamed(CustomisedScreen.routeName);
                        },
                      ),
                      ListTile(
                        title: Text(
                          'Feedback form',
                        ),
                        leading: Icon(
                          Icons.feedback,
                        ),
                        onTap: () {},
                      ),
                      _isAdmin
                          ? Container(
                              child: Column(
                                children: <Widget>[
                                  PopupMenuDivider(),
                                  ListTile(
                                    title: Text(
                                      'Push message',
                                    ),
                                    leading: Icon(
                                      Icons.message,
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pop();

                                      Navigator.of(context)
                                          .pushNamed(SendFCMScreen.routeName);
                                    },
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
