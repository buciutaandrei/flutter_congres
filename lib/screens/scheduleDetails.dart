import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';

import '../providers/schedules.dart';

class ScheduleDetails extends StatefulWidget {
  static String routeName = '/scheduleDetails';

  @override
  _ScheduleDetailsState createState() => _ScheduleDetailsState();
}

class _ScheduleDetailsState extends State<ScheduleDetails> {
  @override
  Widget build(BuildContext context) {
    final _itemId = ModalRoute.of(context).settings.arguments;
    final _schedulesProvider = Provider.of<Schedules>(context);
    final _scheduleItem = _schedulesProvider.scheduleById(_itemId);
    final _userId = Provider.of<Auth>(context, listen: false).userId;

    return ChangeNotifierProvider.value(
      value: _scheduleItem,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_scheduleItem.title),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _scheduleItem.toggleFavourite(_userId);
                setState(() {});
              },
              icon: Icon(
                _scheduleItem.isFavourite ? Icons.star : Icons.star_border,
              ),
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _scheduleItem.title,
              ),
              SizedBox(height: 24),
              Text(
                _scheduleItem.author,
              ),
              SizedBox(height: 24),
              Row(
                children: <Widget>[
                  Text(
                    '${DateFormat('HH:mm').format(_scheduleItem.startHour)} - ${DateFormat('HH:mm').format(_scheduleItem.endHour)}',
                  ),
                  Spacer(),
                  Text(
                    Provider.of<Schedules>(context, listen: false)
                        .getLocationName(_scheduleItem.location),
                  )
                ],
              ),
              SizedBox(height: 24),
              Text(
                _scheduleItem.abstractText,
                textAlign: TextAlign.justify,
              )
            ],
          ),
        ),
      ),
    );
  }
}
