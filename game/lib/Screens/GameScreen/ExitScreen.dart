import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';

import 'package:game/Services/Database.dart';

class ExitScreen extends StatefulWidget {
  final List<dynamic> players;
  final String roomKey;
  ExitScreen(this.players, this.roomKey);

  @override
  _ExitScreenState createState() => _ExitScreenState();
}

class _ExitScreenState extends State<ExitScreen> with TickerProviderStateMixin {
  bool areResultsReady = false;
  AnimationController _listTileAniamtionController;
  Animation<double> _animation;
  @override
  void initState() {
    super.initState();

    _listTileAniamtionController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..addListener(() {})
          ..addStatusListener((AnimationStatus status) {});

    _animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _listTileAniamtionController, curve: Curves.easeInOutCirc));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Hero(tag: "logo", child: Image.asset('assests/logo.png')),
            Text("Results"),
            Container(
                alignment: Alignment.center,
                child: FutureBuilder(
                    future: getResults(widget.roomKey),
                    builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Text("Waiting.....");
                      } else {
                        print("Exitscreen");
                        var result = snapshot.data;
                        List<dynamic> players = widget.players;
                        print(result);
                        print(players);
                        List finalScores = [];

                        for (User aplayer in players) {
                          print(aplayer);
                          print(result[aplayer.uid]);
                          if (result.containsKey(aplayer.uid)) {
                            finalScores.add({aplayer: result[aplayer.uid]});
                          } else {
                            finalScores.add({aplayer: 0});
                          }
                        }

                        print(finalScores);
                        finalScores.sort((a, b) {
                          return (b.values.toList()[0]).compareTo(a.values.toList()[0]);
                        });
                        print(finalScores);
                        print(finalScores[0]);
                        List<User> playerUser = finalScores[0].keys.toList();
                        print(playerUser[0].uid);
                        print(finalScores[0].values.toList());
                        return Container(
                          alignment: Alignment.center,
                          child: ListView.builder(
                            shrinkWrap: true,
                              itemCount: finalScores.length,
                              itemBuilder: (context, index) {
                                playerUser = finalScores[index].keys.toList();
                                List points = finalScores[index].values.toList();
                                
                                return (Card(
                                  
                                  child: ListTile(

                                    leading: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(playerUser[0].photo),
                                    ),
                                    title: Text(playerUser[0].name),
                                    trailing: Text(points[0].toString()),
                                  ),
                                ));
                              }),
                        );
                      }
                    })),
                    RaisedButton(child:Text("Exit"),onPressed: (){
                      
                      Navigator.pop(context);
                    })
          ],
        ),
      )),
    );
  }
}
