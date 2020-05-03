import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/Loading.dart';

import 'package:game/Services/authentication.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  var newColor = Colors.blue[500];

  @override
  Widget build(BuildContext context) {
    if (loading == false) {
      return Scaffold(
        body: Container(
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                
                Hero(tag: "logo", child: Image.asset('assests/logo.png')),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: RaisedButton(
                    onPressed: () async {
                      setState(() {
                        loading = true;
                      });
                      Authentication authh = Authentication();
                      User user = await authh.signinwithgoogle();
                      if (user == null) {
                        setState(() {
                          loading = false;
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Image.asset(
                            'assests/google-1.png',
                            alignment: Alignment.center,
                          ),
                          Text('Login with Google'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Loading();
    }
  }
}
