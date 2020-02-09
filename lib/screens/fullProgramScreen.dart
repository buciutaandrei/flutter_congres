import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedule.dart';
import '../providers/schedules.dart';
import '../widgets/appDrawer.dart';
import '../widgets/dayList.dart';

class FullProgramScreen extends StatefulWidget {
  static String routeName = '/FullProgramScreen';

  @override
  _FullProgramScreenState createState() => _FullProgramScreenState();
}

class _FullProgramScreenState extends State<FullProgramScreen> {
  final int _numberOfDays = 4;
  LocationType _currentLocation = LocationType.SalaA;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final _sch = Provider.of<Schedules>(context);
    if (_sch.schedules.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      await Provider.of<Schedules>(context, listen: false)
          .fetchAndSetProducts();
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Schedules _schedules = Provider.of<Schedules>(context, listen: false);
    String locationName(loc) => _schedules.getLocationName(loc);

    return DefaultTabController(
      length: _numberOfDays,
      child: Scaffold(
        drawer: AppDrawer(),
        appBar: AppBar(
          title: Text('Congres'),
          actions: <Widget>[
            PopupMenuButton(
              offset: Offset.fromDirection(-200, 50),
              onSelected: (value) {
                setState(() {
                  _currentLocation = value;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    locationName(_currentLocation),
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 28,
                  ),
                ],
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: LocationType.SalaA,
                  child: Text(locationName(LocationType.SalaA)),
                ),
                PopupMenuItem(
                  value: LocationType.SalaB,
                  child: Text(locationName(LocationType.SalaB)),
                ),
                PopupMenuItem(
                  value: LocationType.SalaC,
                  child: Text(locationName(LocationType.SalaC)),
                ),
                PopupMenuItem(
                  value: LocationType.SalaD,
                  child: Text(locationName(LocationType.SalaD)),
                ),
              ],
            )
          ],
          bottom: TabBar(
            tabs: <Widget>[
              Tab(child: Text('Day 1')),
              Tab(child: Text('Day 2')),
              Tab(child: Text('Day 3')),
              Tab(child: Text('Day 4')),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : TabBarView(children: [
                for (int i = 0; i < _numberOfDays; i++)
                  DayList(
                      _schedules.schedulesByDayAndLocation(i, _currentLocation),
                      false)
              ]),
      ),
    );
  }
}
