import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedules.dart';
import '../widgets/appDrawer.dart';
import '../widgets/dayList.dart';

class CustomisedScreen extends StatefulWidget {
  static String routeName = '/customisedScreen';

  @override
  _CustomisedScreenState createState() => _CustomisedScreenState();
}

class _CustomisedScreenState extends State<CustomisedScreen> {
  final int _numberOfDays = 4;

  @override
  Widget build(BuildContext context) {
    final Schedules _schedules = Provider.of<Schedules>(context);

    return DefaultTabController(
      length: _numberOfDays,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Congres'),
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Day 1')),
              Tab(child: Text('Day 2')),
              Tab(child: Text('Day 3')),
              Tab(child: Text('Day 4')),
            ],
          ),
        ),
        body: TabBarView(children: [
          for (int i = 0; i < _numberOfDays; i++)
            DayList(_schedules.schedulesByDayAndFavourite(i), true)
        ]),
      ),
    );
  }
}
