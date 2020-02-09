import 'package:flutter/material.dart';
import '../providers/schedule.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

ClassType getClassTypeEnum(String type) {
  switch (type) {
    case 'presentation':
      return ClassType.Presentation;
      break;
    case 'roundTable':
      return ClassType.RoundTable;
      break;
    case 'break':
      return ClassType.Break;
      break;
    default:
      return ClassType.Break;
  }
}

LocationType getLocationTypeEnum(String type) {
  switch (type) {
    case 'A':
      return LocationType.SalaA;
      break;
    case 'B':
      return LocationType.SalaB;
      break;
    case 'C':
      return LocationType.SalaC;
      break;
    case 'D':
      return LocationType.SalaD;
      break;
    default:
      return LocationType.SalaA;
  }
}

class Schedules with ChangeNotifier {
  final String userId;

  Schedules({this.userId});

  List<Schedule> _schedule = [];

  Future<void> fetchAndSetProducts() async {
    final allSchedules =
        (await _firestore.collection('schedule').getDocuments()).documents;
    final allFavourites =
        await _firestore.collection('favourites').document(userId).get();
    allSchedules.forEach((item) {
      _schedule.add(
        Schedule(
          abstractText: item['abstractText'],
          author: item['author'],
          classType: getClassTypeEnum(item['type']),
          location: getLocationTypeEnum(item['location']),
          day: item['day'],
          title: item['title'],
          startHour: DateTime.parse(item['startHour']),
          endHour: DateTime.parse(item['endHour']),
          id: item.documentID,
          isFavourite: allFavourites.exists
              ? allFavourites.data[item.documentID] ?? false
              : false,
        ),
      );
    });
    notifyListeners();
  }

  List<Schedule> get schedules {
    return [..._schedule];
  }

  Schedule scheduleById(String id) {
    return [..._schedule].firstWhere((item) => item.id == id);
  }

  List<Schedule> schedulesByDay(int day) {
    return [..._schedule].where((item) => item.day == day).toList()
      ..sort((a, b) => (a.startHour).compareTo(b.startHour));
  }

  String getLocationName(LocationType loc) {
    switch (loc) {
      case LocationType.SalaA:
        return 'Sala A';
        break;
      case LocationType.SalaB:
        return 'Sala B';
        break;
      case LocationType.SalaC:
        return 'Sala C';
        break;
      case LocationType.SalaD:
        return 'Sala D';
        break;
      default:
        return '';
    }
  }

  List<Schedule> schedulesByDayAndLocation(int day, LocationType location) {
    return [..._schedule]
        .where((item) => item.day == day && item.location == location)
        .toList()
          ..sort((a, b) => (a.startHour).compareTo(b.startHour));
  }

  List<Schedule> schedulesByDayAndFavourite(int day) {
    return [..._schedule]
        .where((item) => item.day == day && item.isFavourite == true)
        .toList()
          ..sort((a, b) => (a.startHour).compareTo(b.startHour));
  }
}
