import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/CreateRoom/CreateRoom.dart';
import 'package:game/Screens/HomeScreen/Profile.dart';
import 'package:game/Screens/JoinRoom/JoinRoom.dart';
import 'package:game/Screens/Loading.dart';
import 'package:game/Services/authentication.dart';
import 'package:progress_indicators/progress_indicators.dart';
import 'package:provider/provider.dart';
import 'package:game/Services/Database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (loading == false) {
      return Scaffold(
          backgroundColor: Color(0x040C0E), 
          body: SizedBox.expand(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  
                  children: <Widget>[
                    Container(
                      alignment: Alignment.center,
                      height: 100,
                      child: ClipRRect(child:FadeInImage.assetNetwork(
                          placeholder: 'assests/loader-1.gif',
                          placeholderScale: 2,
                          image: user.photo,
                          
                        ),
                        borderRadius: BorderRadius.circular(50),
                        
                        ),
                    ),

                      SizedBox(height:20.0),
                    
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        user.name,
                       
                      ),
                    ),
                    RaisedButton(
                      onPressed: () async {
                        setState(() {
                          loading = true;
                        });
                        String roomkey = await createRoom(user);
                        print("fromm homescreen");

                        Navigator.of(context).push
                        
                        
                        (
                            MaterialPageRoute(builder: (context) {
                          print(roomkey);

                          return Userloggedin(
                              child: CreateRoom(),
                              user: user,
                              roomkey: roomkey);
                        }));
                      },
                      textColor: Colors.black,
                      child: Text("Create Room"),
                      
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context)
                            .push(MaterialPageRoute(builder: (context) {
                          return Userloggedin(
                              child: JoinRoom(user: user), user: user);
                        }));
                      },
                      textColor: Colors.black,
                      child: Text("Join Room"),
                      elevation: 10.0,
                    
                      colorBrightness: Brightness.dark,
                      color: Colors.blue,
                    ),
                    FlatButton(
                      child: Text(
                        "Logout",
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      onPressed: () async {
                        Authentication authh = Authentication();
                        await authh.signoutwithgoogle().whenComplete(() {
                          print('Signout');
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          ));
    } else {
      return Loading();
    }
  }
}

class Userloggedin extends InheritedWidget {
  final User user;
  final String roomkey;
  Userloggedin({this.user, this.child, this.roomkey}) : super(child: child);

  final Widget child;

  static Userloggedin of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType());
  }

  @override
  bool updateShouldNotify(Userloggedin oldWidget) {
    return true;
  }
}
