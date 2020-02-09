import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/schedule.dart';
import './scheduleItem.dart';
import './breakItem.dart';

class DayList extends StatelessWidget {
  final List<Schedule> _schedules;
  final bool _selectedFavourites;

  DayList(this._schedules, this._selectedFavourites);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: _schedules.length,
        itemBuilder: (context, index) => ChangeNotifierProvider.value(
          value: _schedules[index],
          child: _schedules[index].classType == ClassType.Presentation
              ? ScheduleItem(_selectedFavourites)
              : _selectedFavourites ? Container() : BreakItem(),
        ),
      ),
    );
  }
}
