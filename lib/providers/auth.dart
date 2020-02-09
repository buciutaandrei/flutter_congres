import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _auth = FirebaseAuth.instance;
final _firestore = Firestore.instance;
final _googleSignIn = GoogleSignIn();

class Auth with ChangeNotifier {
  String _userId;
  String _token;
  DateTime _expiryDate;
  Timer _authTimer;
  bool _isAdmin;

  String get userId {
    return _userId;
  }

  bool get isAuth {
    return _token != null;
  }

  bool get isAdmin {
    return _isAdmin ?? false;
  }

  Future _savePrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final saveData = json.encode({
      'token': _token,
      'userId': _userId,
      'expiryDate': _expiryDate.toIso8601String(),
      'isAdmin': _isAdmin ?? false
    });
    await prefs.setString('userData', saveData);
  }

  void _addUserToDatabase(FirebaseUser user) {
    _firestore.collection('users').document(_userId).setData({
      'userId': _userId,
      'email': user.email,
      'displayName': user.displayName,
      'registerDate': DateTime.now().toIso8601String(),
    }, merge: true);
  }

  Future<void> signUp(email, password, displayName) async {
    final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
            email: email, password: password))
        .user;
    _userId = user.uid;
    IdTokenResult userData = await user.getIdToken();
    _token = userData.token;
    _expiryDate = userData.expirationTime;

    _addUserToDatabase(user);
    await _savePrefs();
    notifyListeners();
  }

  Future<void> signIn(email, password) async {
    final createdUser = (await _auth.signInWithEmailAndPassword(
            email: email, password: password))
        .user;
    _userId = createdUser.uid;

    final isAdmin =
        (await _firestore.collection('users').document(_userId).get())
            .data['isAdmin'];
    _isAdmin = isAdmin;

    IdTokenResult userData = await createdUser.getIdToken();
    _token = userData.token;
    _expiryDate = userData.expirationTime;

    await _savePrefs();
    notifyListeners();
  }

  Future<void> signInAnonymously() async {
    final FirebaseUser user = (await _auth.signInAnonymously()).user;

    _userId = user.uid;
    _token = (await user.getIdToken()).token;
    _expiryDate = (await user.getIdToken()).expirationTime;

    _addUserToDatabase(user);
    await _savePrefs();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    _userId = user.uid;
    _token = (await user.getIdToken()).token;
    _expiryDate = (await user.getIdToken()).expirationTime;
    _isAdmin = (await Firestore.instance
        .collection('users')
        .document(_userId)
        .get())['isAdmin'];

    _addUserToDatabase(user);
    await _savePrefs();
    notifyListeners();
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey('userData')) {
      return false;
    }

    final extractedUserData =
        json.decode(prefs.getString('userData')) as Map<String, Object>;

    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (!expiryDate.isAfter(DateTime.now())) {
      return false;
    }

    _isAdmin = extractedUserData['isAdmin'];
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    _autoLogOut();
    notifyListeners();
    return true;
  }

  Future<void> signOut() async {
    _auth.signOut();
    _userId = null;
    _token = null;
    _isAdmin = false;
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  void _autoLogOut() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry = _expiryDate.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), signOut);
  }
}
