import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/CreateRoom/tile.dart';
import 'package:game/Screens/GameScreen/GameScreenWrapper.dart';
import 'package:game/Screens/HomeScreen/Profile.dart';
import 'package:game/Screens/Loading.dart';
import 'package:game/Services/Database.dart';
import 'package:game/Models/Room.dart';

class CreateRoom extends StatefulWidget {
  CreateRoom();
  @override
  _CreateRoomState createState() => _CreateRoomState();
}

class _CreateRoomState extends State<CreateRoom> {
  bool startgame = false;
  @override
  Widget build(BuildContext context) {
    print("From inherited widget:");
    User user = Userloggedin.of(context).user;
    String roomKey = Userloggedin.of(context).roomkey;

    return StreamBuilder<Room>(
      stream: roomdata(roomKey),
      builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {
        print("<:><:><:><:><:><:><:>");
        print(snapshot.data);

        print("<:><:><:><:><:><:><:>");
        Room room = snapshot.data;
        //print(room.owneruid);
        if (snapshot.hasData && snapshot.data != null) {
          List<dynamic> players = snapshot.data.players;
          print(players);
          if (room.hasGameStarted == false) {
            return Scaffold(
              backgroundColor: Colors.amber[200],
              body: SafeArea(
                child: Container(
                  alignment: Alignment.center,
                  child: Container(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Hero(
                            tag: "logo", child: Image.asset('assests/logo.png')),
                      ),
                      Text('Room Key'),
                      Text(roomKey),
                      ListView.builder(
                          itemCount: players.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Tile(
                              name: players[index].name,
                              photo: players[index].photo,
                            );
                          }),
                      user.uid == room.owneruid
                          ? RaisedButton(
                              onPressed: () {
                                Firestore.instance
                                    .collection('rooms')
                                    .document(roomKey)
                                    .updateData({
                                  "game Started": true,
                                });
                              },
                              child: Text("Start Game"),
                            )
                          : Text('Room owner will start the game'),
                    ],
                  )),
                ),
              ),
            );
          } else {
            return GamescreenWrapper(
                roomKey: roomKey, roundnumber: 0, user: user);
          }
        } else {
          return Loading();
        }
      },
    );
  }
}
