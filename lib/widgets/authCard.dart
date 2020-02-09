import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

enum AuthScreen { Register, SignIn }

class AuthCard extends StatefulWidget {
  final Function rotateCard;

  AuthCard({this.rotateCard});

  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard>
    with SingleTickerProviderStateMixin {
  AuthScreen _authScreen = AuthScreen.SignIn;

  String _displayName, _password, _email;
  bool _isLoading = false;

  final _formKey = GlobalKey<FormState>();
  final _passwordConfirmController = TextEditingController();
  final _passwordController = TextEditingController();

  AnimationController _controller;
  Animation<Offset> _slideAnimation;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _slideAnimation = Tween<Offset>(begin: Offset(0, 0), end: Offset(0, -1.5))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Error occured'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void _submitForm() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final auth = Provider.of<Auth>(context, listen: false);
      _formKey.currentState.save();

      if (_authScreen == AuthScreen.Register) {
        await auth.signUp(_email, _password, _displayName);
      } else {
        await auth.signIn(_email, _password);
      }
    } catch (error) {
      final PlatformException errorData = error;

      _showErrorDialog(errorData.message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Card(
      elevation: 8,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        constraints: BoxConstraints(
            minHeight: _authScreen == AuthScreen.Register ? 420 : 320),
        curve: Curves.easeIn,
        height: _authScreen == AuthScreen.Register ? 420 : 320,
        width: deviceSize.width * 0.75,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    _authScreen == AuthScreen.Register ? 'Register' : 'Sign In',
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Form(
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            onSaved: (value) => _email = value.trim(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              icon: Icon(
                                Icons.mail,
                              ),
                            ),
                          ),
                          TextFormField(
                            onSaved: (value) => _password = value.trim(),
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: 'Password',
                                icon: Icon(
                                  Icons.lock,
                                )),
                          ),
                          AnimatedContainer(
                            curve: Curves.easeIn,
                            constraints: BoxConstraints(
                                minHeight:
                                    _authScreen == AuthScreen.Register ? 60 : 0,
                                maxHeight: _authScreen == AuthScreen.Register
                                    ? 120
                                    : 0),
                            duration: Duration(milliseconds: 300),
                            child: FadeTransition(
                              opacity: _opacityAnimation,
                              child: SlideTransition(
                                position: _slideAnimation,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: <Widget>[
                                      TextFormField(
                                        enabled:
                                            _authScreen == AuthScreen.Register,
                                        controller: _passwordConfirmController,
                                        obscureText: true,
                                        validator: _authScreen ==
                                                AuthScreen.Register
                                            ? (value) {
                                                if (value.trim() !=
                                                    _passwordController.text) {
                                                  return "Password does not match";
                                                }
                                                return null;
                                              }
                                            : null,
                                        decoration: InputDecoration(
                                            labelText: 'Confirm password',
                                            icon: Icon(
                                              Icons.check,
                                            )),
                                      ),
                                      TextFormField(
                                        enabled:
                                            _authScreen == AuthScreen.Register,
                                        onSaved: (value) =>
                                            _displayName = value.trim(),
                                        decoration: InputDecoration(
                                            labelText: 'Username',
                                            icon: Icon(
                                              Icons.person,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  _isLoading
                      ? CircularProgressIndicator()
                      : RaisedButton(
                          onPressed: () {
                            _submitForm();
                          },
                          child: Text(
                            _authScreen == AuthScreen.Register
                                ? 'Register'
                                : 'Sign In',
                          ),
                        ),
                  FlatButton(
                    child: Text(
                      _authScreen == AuthScreen.Register
                          ? 'Sign In'
                          : 'Register',
                    ),
                    onPressed: () {
                      setState(() {
                        _authScreen = _authScreen == AuthScreen.Register
                            ? AuthScreen.SignIn
                            : AuthScreen.Register;
                      });
                    },
                  ),
                  FlatButton(
                    child: Text(
                      'Select Sign In Mode',
                    ),
                    onPressed: () => widget.rotateCard(),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
