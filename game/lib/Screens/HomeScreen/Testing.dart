import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/HomeScreen/Profile.dart';
import 'package:provider/provider.dart';

class HomePageTest extends StatefulWidget {
  @override
  _HomePageTestState createState() => _HomePageTestState();
}

class _HomePageTestState extends State<HomePageTest> {
  @override
  Widget build(BuildContext context) {
    
    return Container(
      child: Stack(
        
        alignment: Alignment.topLeft,
        children: <Widget>[
          Container(
            height: 100.0,
            color: Colors.amberAccent,
            
            
          
          ),
          Profile(),
          
        ],

      ),
    );
  }
}