import '../providers/schedules.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import '../providers/schedule.dart';
import '../screens/scheduleDetails.dart';

class ScheduleItem extends StatelessWidget {
  final bool _selectedFavourites;

  ScheduleItem(this._selectedFavourites);

  @override
  Widget build(BuildContext context) {
    final scheduleItem = Provider.of<Schedule>(context);
    String getLocationName(loc) =>
        Provider.of<Schedules>(context, listen: false).getLocationName(loc);
    final String _userId = Provider.of<Auth>(context, listen: false).userId;

    return Card(
      elevation: 2,
      child: ListTile(
        onTap: () {
          Navigator.of(context)
              .pushNamed(ScheduleDetails.routeName, arguments: scheduleItem.id);
        },
        title: Text(
          scheduleItem.title,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: _selectedFavourites
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    scheduleItem.author,
                  ),
                  Text(
                    getLocationName(scheduleItem.location),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  scheduleItem.author,
                ),
              ),
        leading: CircleAvatar(
          radius: 28,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              children: <Widget>[
                Text(
                  DateFormat('HH:mm').format(scheduleItem.startHour),
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
                Divider(
                  height: 8,
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Text(
                  DateFormat('HH:mm').format(scheduleItem.endHour),
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            scheduleItem.isFavourite ? Icons.star : Icons.star_border,
            size: 32,
          ),
          onPressed: () {
            scheduleItem.toggleFavourite(_userId);
          },
        ),
      ),
    );
  }
}
