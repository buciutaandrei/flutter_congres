import 'package:congres_app/widgets/animatedBackground.dart';
import 'package:congres_app/widgets/particleWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/authCard.dart';
import '../providers/auth.dart';
import 'dart:math';

class AuthenticationScreen extends StatefulWidget {
  static const routeName = '/authenticationScreen';

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  AnimationStatus _animationStatus = AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        _animationStatus = status;
      });
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void _rotateCard() {
    setState(() {
      if (_animationStatus == AnimationStatus.dismissed) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _auth = Provider.of<Auth>(context);
    final deviceSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: FancyBackground(),
          ),
          Positioned.fill(child: Particles(30)),
          SingleChildScrollView(
            child: Container(
              height: deviceSize.height,
              width: deviceSize.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: deviceSize.width > 600 ? 2 : 1,
                    child: Transform(
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateY(pi * _animation.value),
                      child: _animation.value > 0.5
                          ? Transform(
                              alignment: FractionalOffset.center,
                              transform: Matrix4.identity()
                                ..setEntry(3, 2, 0.001)
                                ..rotateY(pi),
                              child: AuthCard(rotateCard: _rotateCard))
                          : Card(
                              elevation: 1,
                              child: Container(
                                height: 240,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Choose Sign-In Method',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 16,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        _rotateCard();
                                      },
                                      child: Text(
                                        'Sign In with Username',
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        _auth.signInWithGoogle();
                                      },
                                      child: Text(
                                        'Sign In with Google',
                                      ),
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        _auth.signInAnonymously();
                                      },
                                      child: Text(
                                        'Sign In as Anonymous',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
