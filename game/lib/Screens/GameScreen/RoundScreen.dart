import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Models/playersData.dart';
import 'package:game/Screens/GameScreen/WaitingScreen.dart';
import 'package:game/Screens/Loading.dart';
import 'package:game/Services/Database.dart';
import 'package:provider/provider.dart';

class RoundScreen extends StatefulWidget {
  final String roomKey;
  final User user;
  final int roundNo;

  const RoundScreen({this.roomKey, this.user, this.roundNo});

  @override
  _RoundScreenState createState() => _RoundScreenState();
}

class _RoundScreenState extends State<RoundScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
        value: playerdata(widget.roomKey, widget.roundNo.toString()),
        child: Jugaad(
            roomKey: widget.roomKey,
            roundNo: widget.roundNo,
            user: widget.user));
  }
}

class Jugaad extends StatefulWidget {
  final String roomKey;
  final User user;
  final int roundNo;

  const Jugaad({this.roomKey, this.user, this.roundNo});
  @override
  _JugaadState createState() => _JugaadState();
}

class _JugaadState extends State<Jugaad> {
  bool iswordsubmitted = false;
  String word = '';
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<List<playersData>>(context);
    print(data);
    String roleDef;
    if (data != null) {
      for (var player in data) {
        if (player.uid == widget.user.uid) {
          if (player.role == "master") {
            roleDef =
                "According to your word,your friends have to tell why theirs word is related to yours";
          } else {
            roleDef =
                "Select a random word,Later on you have to tell why your word is related to one of your's friend's word";
          }
        }
      }
    }

    print('round-screen');
    print(data);

    print(widget.user.uid);
    if (data != null) {
      if (iswordsubmitted == false) {
        return Scaffold(
            body: SafeArea(
          child: Form(
            key: _formKey,
            child: Stack(
              children: <Widget>[
                Align(
                    alignment: Alignment.topCenter,
                    child: Hero(
                        tag: "logo", child: Image.asset('assests/logo.png'))),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    padding: EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(hintText: "Enter Word"),
                          validator: (val) =>
                              val.isEmpty ? 'Jyada oversmart na bane' : null,
                          onChanged: (val) {
                            setState(() {
                              print(val);
                              word = val;
                              print(word);
                            });
                          },
                        ),
                        RaisedButton(
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                print(word);
                                await addword(
                                    widget.roomKey,
                                    widget.roundNo.toString(),
                                    word,
                                    widget.user.uid);

                                setState(() {
                                  iswordsubmitted = true;
                                });
                              }
                            },
                            child: Text('Submit Word')),
                        Text(roleDef)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
      } else {
        //return(Text('waitingScreen'));
        return WaitingScreen(
            roomKey: widget.roomKey,
            roundNo: widget.roundNo.toString(),
            user: widget.user);
      }
    } else {
      return Loading();
    }
  }
}
