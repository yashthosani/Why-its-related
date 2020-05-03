import 'package:flutter/material.dart';
import 'package:game/Models/Room.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/GameScreen/ExitScreen.dart';
import 'package:game/Screens/GameScreen/RoundScreen.dart';
import 'package:game/Screens/HomeScreen/HomeScreen.dart';
import 'package:game/Screens/Loading.dart';
import 'package:game/Services/Database.dart';
import 'package:provider/provider.dart';

class GamescreenWrapper extends StatefulWidget {
  final String roomKey;
  final int roundnumber;
  final User user;
  const GamescreenWrapper({this.roomKey,this.roundnumber,this.user}) ;
  @override
  _GamescreenWrapperState createState() => _GamescreenWrapperState();
}

class _GamescreenWrapperState extends State<GamescreenWrapper> {


  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Room>(
      stream: roomdata(widget.roomKey),
      builder: (BuildContext context, AsyncSnapshot<Room> snapshot) {

        if (snapshot.hasData){
          Room room=snapshot.data;
          int max_rounds=room.players.length;
          
          if(widget.roundnumber<max_rounds){
            int round_num=widget.roundnumber + 1;
            if(room.owneruid==widget.user.uid)
            {
              createRound(round_num, widget.roomKey, room.players);
            }
            return RoundScreen(roomKey: room.roomid,roundNo: round_num,user: widget.user);
            
          }
          else{
            
            return ExitScreen(room.players,widget.roomKey);
          }
        
        }
        else{
          return(Loading());
        }
        
      },
    );
  }
}
