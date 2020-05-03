import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Models/playersData.dart';
import 'package:game/Screens/GameScreen/GameScreenWrapper.dart';
import 'package:game/Screens/Loading.dart';
import 'package:game/Services/Database.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'StatusTile.dart';

class AfterResponseWaitingScreen extends StatefulWidget {
  final String roomKey;
  final User user;
  final String roundNo;

  const AfterResponseWaitingScreen({this.roomKey, this.user, this.roundNo});
  @override
  _AfterResponseWaitingScreenState createState() =>
      _AfterResponseWaitingScreenState();
}

class _AfterResponseWaitingScreenState
    extends State<AfterResponseWaitingScreen> {
  var winnerplayer;
  bool iswinnerselected = false;
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<List<playersData>>(context);

    print("----------------: After Response Waiting screen :-----------------");

    if (data != null && data.length > 0) {
      bool ismaster = false;
      bool isroomowner = false;
      Map master;
      var roomowner;

      bool isroundfinished = data[0].roundFinished;
      print('isroundfinished');
      print(isroundfinished);

      if (widget.user.uid == data[0].player['uid']) {
        setState(() {
          
          isroomowner = true;
        });
      }

      List<bool> answerlist = [];
      for (var player in data) {
        print(player.response);
        if (player.response == '') {
          if (player.role == 'master') {
            
            roomowner = data[0].player['name'];
            answerlist.add(true);
          } else {
            print(player.points);

            answerlist.add(false);
          }
        } else {
          if (player.points == 10) {
            setState(() {
              iswinnerselected = true;
            });
          }
          answerlist.add(true);
        }

        if (widget.user.uid == player.uid) {
          print(player.role);
          if (player.role == "master") {
            master = player.player;
            ismaster = true;
          } else {
            ismaster = false;
          }
        }
      }
      print(
          "+++++++++++++++++++++++++++++++ Status ++++++++++++++++++++++++++++++++++++++++++++++");
      print(iswinnerselected);
      print(winnerplayer);

      Widget statusWid() {
        print("[][][][][]");
        debugPrint("answerlist");
        print(answerlist.contains(false));
        print("ismaster");
        print(ismaster);
        print("isroomowner");
        print(isroomowner);
        print("iswinnerselected");
        print(iswinnerselected);
        print("winnerplayer");
        print(winnerplayer);
        print("master");
        print(master);
        if (answerlist.contains(false) == false) {
          if (ismaster == true) {
            if (iswinnerselected == false) {
              return Text("Please Select a winner");
            } else {
              if (isroomowner) {
                return RaisedButton(
                    onPressed: () async {
                      await finishRoundandStartNewRound(
                          widget.roomKey, widget.roundNo, widget.user.uid);
                      setState(() {
                        isroundfinished = true;
                      });
                    },
                    child: Text("Next Round"));
              } else {
                return (Text("Waiting for room owner to start next round"));
              }
            }
          } else {
            if (iswinnerselected == true) {
              if (isroomowner == true) {
                return RaisedButton(
                    onPressed: () async {
                      await finishRoundandStartNewRound(
                          widget.roomKey, widget.roundNo, widget.user.uid);
                      setState(() {
                        isroundfinished = true;
                      });
                    },
                    child: Text("Next Round"));
              } else {
                return Text("Waiting for $roomowner to start next round");
              }
            } else {
              return Text("Waiting for $master to select winner");
            }
          }
        } else {
          return Text("Waiting for others to respond");
        }
      }

      return isroundfinished == null
          ? Scaffold(
              body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Hero(tag: "logo", child: Image.asset('assests/logo.png')),
                    ismaster
                        ? Text(
                            "According to you, who has a best answer Tap to select it")
                        : SizedBox(height: 0.0),
                    Container(
                      child: ListView.builder(
                          itemCount: data.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            print(data);
                            bool status = false;

                            print("from listview");
                            print(index);
                            print(data[index].player);
                            print(data[index].word);
                            print(data[index].role);
                            print(data[index].response);
                            print(data[index].points);
                            print(winnerplayer);
                            if (data[index].response != '') {
                              status = true;
                            } else {
                              if (data[index].role == 'master') {
                                status = true;
                              } else {
                                status = false;
                              }
                            }

                            return GestureDetector(
                              onTap: ismaster
                                  ? () async {
                                      await getResults(widget.roomKey);
                                      print(widget.roomKey);
                                      if (answerlist.contains(false) == false) {
                                        if (iswinnerselected == false) {
                                          if (master['uid'] ==
                                              data[index].player['uid']) {
                                            Fluttertoast.showToast(
                                              msg: "You cannot select yourself",
                                              toastLength: Toast.LENGTH_LONG,
                                            );
                                          } else {
                                            setState(() {
                                              winnerplayer = data[index].player;
                                            });
                                            await addPoints(widget.roomKey,
                                                widget.roundNo, winnerplayer);
                                            setState(() {
                                              iswinnerselected = true;
                                            });
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                "Winner player already selected",
                                            toastLength: Toast.LENGTH_LONG,
                                          );
                                        }
                                        print("master");
                                      } else {
                                        print(winnerplayer);
                                        Fluttertoast.showToast(
                                          msg: "Wait for everyone to respond",
                                          toastLength: Toast.LENGTH_LONG,
                                        );
                                      }

                                      print("From Tap");
                                      print(winnerplayer);
                                    }
                                  : () {
                                      print(iswinnerselected);
                                      print("not master");
                                    },
                              child: Container(
                                margin: EdgeInsets.all(5.0),
                                color:
                                    data[index].points == 10 && ismaster == true
                                        ? Colors.green
                                        : Colors.amber[700],
                                padding: EdgeInsets.all(2.0),
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Column(
                                  children: <Widget>[
                                    StatusTile(
                                        name: data[index].player['name'],
                                        photo: data[index].player['photo'],
                                        status: status),
                                    Container(
                                      margin: EdgeInsets.fromLTRB(
                                          10.0, 5.0, 10.0, 0.0),
                                      width: double.infinity,
                                      alignment: Alignment.centerLeft,
                                      padding: EdgeInsets.fromLTRB(
                                          5.0, 5.0, 5.0, 5.0),
                                      color: Colors.amber[100],
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(4.0),
                                              color:Colors.amber[500],
                                              width: double.infinity,
                                              child: Text(data[index].word)),
                                          data[index].response != ""
                                              ? Container(
                                                  color:Colors.amber[500],
                                                  width: double.infinity,
                                                  padding: EdgeInsets.all(4.0),
                                                  margin:EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
                                                  child: Text(
                                                      data[index].response))
                                              : SizedBox(
                                                  height: 0,
                                                  width: 0,
                                                ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    statusWid(),
                  ],
                ),
              ),
            ))
          : GamescreenWrapper(
              roomKey: widget.roomKey,
              roundnumber: int.parse(widget.roundNo),
              user: widget.user,
            );
    } else {
      return (Loading());
    }
  }
}
