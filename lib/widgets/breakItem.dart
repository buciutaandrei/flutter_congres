import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/schedule.dart';

class BreakItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheduleItem = Provider.of<Schedule>(context);

    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(DateFormat('HH:mm').format(scheduleItem.startHour)),
              Text(' - '),
              Text(DateFormat('HH:mm').format(scheduleItem.endHour)),
            ],
          ),
          Text(scheduleItem.title)
        ],
      ),
    );
  }
}
