import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/HomeScreen/HomeScreen.dart';
import 'package:game/Services/authentication.dart';
import 'package:provider/provider.dart';
import 'Screens/Wrapper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: Authentication().user,
      child: MaterialApp(
        theme: ThemeData.light().copyWith(
          
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.amber[200],
          textTheme: TextTheme(body1: TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontFamily: "Pacifico"),
          body2: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: "Pacifico"),
          subhead:  TextStyle(color: Colors.black,fontWeight: FontWeight.normal,fontFamily: "Pacifico"),
          button: TextStyle(color: Colors.white),
          ),
          primaryColor:Colors.amber[500] ,
          backgroundColor: Colors.amber[500],
          cardTheme: CardTheme(color:Colors.amber[100],elevation: 10,margin:EdgeInsets.fromLTRB(0, 0, 0, 5), ),
            buttonTheme: ButtonThemeData(
                buttonColor: Color.fromRGBO(190, 144, 99, 8),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                materialTapTargetSize: MaterialTapTargetSize.padded,
                ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.amber[100],
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0)),
              focusedBorder: OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Colors.orange[500], width: 2.0)),
            )),
        initialRoute: '/',
        routes: {
          '/': (context) => Wrapper(),
          '/homescreen': (context) => HomeScreen(),
        },
      ),
    );
  }
}
