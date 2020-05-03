import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/HomeScreen/Profile.dart';
import 'package:game/Screens/HomeScreen/Testing.dart';
import 'package:provider/provider.dart';

import 'HomeScreen/HomeScreen.dart';
import 'LoginScreen/LoginScreen.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user =Provider.of<User>(context);
    print(user);
    //print(user.name);
    if(user == null){
      return LoginScreen();
    }
    else{
      return Profile();
    }
  }
}