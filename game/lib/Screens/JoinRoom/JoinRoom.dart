import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/CreateRoom/CreateRoom.dart';
import 'package:game/Screens/HomeScreen/Profile.dart';
import 'package:game/Services/Database.dart';

class JoinRoom extends StatefulWidget {
  final User user;

  const JoinRoom({this.user});

  @override
  _JoinRoomState createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> {
  final _formKey = GlobalKey<FormState>();
  String roomkey;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      
      body: SafeArea(
        maintainBottomViewPadding: true,
        minimum: EdgeInsets.all(8.0),
        child: Stack(children: <Widget>[
          Align(
            alignment: Alignment.topLeft,
            
            child: RaisedButton(
              
                child: Text("back"),
                onPressed: () {
                  Navigator.pop(context);
                }),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
                key: _formKey,
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  
                    Hero(tag: "logo", child: Image.asset('assests/logo.png')),
                    
                    TextFormField(
                      decoration: InputDecoration(hintText: "Enter Room Key"),
                      keyboardType: TextInputType.number,
                      onChanged: (val) {
                        setState(() {
                          roomkey = val;
                          print(roomkey);
                        });
                      },
                    ),
                    RaisedButton(
                        onPressed: ()async {
                          String room =await joinroom(widget.user, roomkey);
                          if (room != null){
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(builder: (context) {
                            return Userloggedin(
                                child: CreateRoom(),
                                user: widget.user,
                                roomkey: roomkey);
                          }));}else{
                            Fluttertoast.showToast(
                                            msg:
                                                "Room Doesn't exist",
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                          }
                        },
                        child: Text("Enter room")),
                  ],
                )),
          ),
        ]),
      ),
    );
  }
}
