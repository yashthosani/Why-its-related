import 'package:flutter/material.dart';
import 'package:progress_indicators/progress_indicators.dart';


class Loading extends StatelessWidget {
  const Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(8, 27, 51, 1),
      body: Container(alignment: Alignment.center,
      child:Column(crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
        Image.asset('assests/loader.gif'),
        Text("Loading...."),
      ],) ),
    );
  }
}