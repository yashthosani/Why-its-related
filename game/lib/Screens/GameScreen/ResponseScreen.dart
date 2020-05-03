import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Models/playersData.dart';
import 'package:game/Screens/GameScreen/AfterResponseWatingScreen.dart';
import 'package:game/Screens/Loading.dart';
import 'package:game/Services/Database.dart';
import 'package:provider/provider.dart';

class ResponseScreen extends StatefulWidget {
  final String roomKey;
  final User user;
  final String roundNo;

  const ResponseScreen({this.roomKey, this.user, this.roundNo});

  @override
  _ResponseScreenState createState() => _ResponseScreenState();
}

class _ResponseScreenState extends State<ResponseScreen> {
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
  final String roundNo;

  const Jugaad({this.roomKey, this.user, this.roundNo});
  @override
  _JugaadState createState() => _JugaadState();
}

class _JugaadState extends State<Jugaad> {
  bool isresponsesubmitted = false;
  String word = '';
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<List<playersData>>(context);
    String masterword;
    String playerword;
    if (data != null) {
      for (var player in data) {
        if (player.role == "master") {
          masterword = player.word;
        } else if (player.uid == widget.user.uid) {
          playerword = player.word;
        }
      }
    }
    print('response-screen');
    print(data);

    print(widget.user.uid);
    if (data != null) {
      if (isresponsesubmitted == false) {
        return Scaffold(
          
            body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text("Why $playerword is related to $masterword?"),
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.multiline
                        ,
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
                      FlatButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                            print(word);
                            await addResponse(widget.roomKey,
                                widget.roundNo.toString(), word, widget.user.uid);

                            setState(() {
                              isresponsesubmitted = true;
                            });
                            }
                          },
                          child: Text('Submit Response')),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
      } else {
        //return(Text('waitingScreen'));
        return StreamProvider<List<playersData>>.value(
          value: playerdata(widget.roomKey, widget.roundNo),
          child: AfterResponseWaitingScreen(
              roomKey: widget.roomKey,
              roundNo: widget.roundNo,
              user: widget.user),
        );
      }
    } else {
      return Loading();
    }
  }
}
