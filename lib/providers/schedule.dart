import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum ClassType { Presentation, Break, RoundTable }
enum LocationType { SalaA, SalaB, SalaC, SalaD }

class Schedule with ChangeNotifier {
  String id;
  int day;
  ClassType classType;
  String title;
  String author;
  String abstractText;
  DateTime startHour;
  DateTime endHour;
  LocationType location;
  bool isFavourite;
  double rating;
  double finalRating;

  final _firestore = Firestore.instance;

  Schedule({
    @required this.id,
    @required this.classType,
    @required this.day,
    @required this.abstractText,
    @required this.author,
    @required this.endHour,
    @required this.startHour,
    @required this.title,
    @required this.location,
    this.rating = 5.0,
    this.finalRating = 0.0,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite(String userId) async {
    isFavourite = !isFavourite;

    _firestore
        .collection('favourites')
        .document(userId)
        .setData({id: isFavourite}, merge: true);

    notifyListeners();
  }
}
