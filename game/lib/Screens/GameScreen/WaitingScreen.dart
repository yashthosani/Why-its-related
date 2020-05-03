import 'dart:async';

import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Models/playersData.dart';
import 'package:game/Screens/GameScreen/AfterResponseWatingScreen.dart';
import 'package:game/Screens/GameScreen/ResponseScreen.dart';

import 'package:game/Screens/Loading.dart';
import 'package:game/Services/Database.dart';

import 'StatusTile.dart';

class WaitingScreen extends StatefulWidget {
  final String roomKey;
  final User user;
  final String roundNo;

  const WaitingScreen({this.roomKey, this.user, this.roundNo});
  @override
  _WaitingScreenState createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  // bool checkAllAnswered(List<bool> answers) {
  //   bool result = true;

  //   for (bool answer in answers) {
  //     if (answer == false) {
  //       result = false;
  //     }
  //   }
  //   return result;
  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: playerdata(widget.roomKey, widget.roundNo),
        builder: (BuildContext context, AsyncSnapshot snapshot) {

           
          print("----------------:Waiting screen:-----------------");
          print(snapshot.data);

          if (snapshot.data != null && snapshot.data.length > 0) {
            var data = snapshot.data;
            bool ismaster;

            List<bool> answerlist = [];
            for (var player in data) {
              print(player.word);
              if (player.word == '') {
                answerlist.add(false);
              } else {
                answerlist.add(true);
              }
              print(widget.user.uid);
              print(player.uid);
              if (widget.user.uid == player.uid) {
                print(player.role);
                if (player.role == "master") {
                  ismaster = true;
                } else {
                  ismaster = false;
                }
              }
            }

            print(ismaster);

            // print(data[0].role);

            if (answerlist.contains(false)) {
              return Scaffold(
                      body: SafeArea(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Hero(tag: "logo", child: Image.asset('assests/logo.png')),
                            ),
                            ListView.builder(
                                itemCount: data.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  bool status = false;

                                  print("waiting-screen-list-view");

                                  print(data[index].word);
                                  

                                  if (data[index].word!='') {
                                    status = true;
                                  } else {
                                    status = false;
                                  }

                                  //return Text(players[index].role);
                                  return StatusTile(
                                      name: data[index].player['name'],
                                      photo: data[index].player['photo'],
                                      status: status);
                                }),
                          ],
                        ),
                      ));
                
              
            } else {
               

              if (ismaster == true) {
                return AfterResponseWaitingScreen(roomKey: widget.roomKey,roundNo:widget.roundNo ,user: widget.user,);
              } else {
                return ResponseScreen(roomKey: widget.roomKey,roundNo: widget.roundNo,user: widget.user);
              }
            }
          } else {
            return (Loading());
          }
        });
  }
}
