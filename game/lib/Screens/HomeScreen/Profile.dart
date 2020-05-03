import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:game/Screens/CreateRoom/CreateRoom.dart';
import 'package:game/Screens/JoinRoom/JoinRoom.dart';
import 'package:game/Screens/Loading.dart';
import 'package:game/Services/Database.dart';
import 'dart:math';

import 'package:game/Services/authentication.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

enum _animationStatus { closed, open, animating }

class _ProfileState extends State<Profile> with TickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _animation;

  //AnimationController _fadeinAnimationController;
  //Animation<double> _fadeinAnimation;

  _animationStatus profileanimationstatus = _animationStatus.closed;
  handleProfileOpenClose() {
    if (profileanimationstatus == _animationStatus.closed) {
      _animationController.forward().orCancel;
    } else if (profileanimationstatus == _animationStatus.open) {
      _animationController.reverse().orCancel;
    }
  }

  @override
  void initState() {
    super.initState();
    //Animation for profile page
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          profileanimationstatus = _animationStatus.open;
        } else if (status == AnimationStatus.dismissed) {
          profileanimationstatus = _animationStatus.closed;
        } else {
          profileanimationstatus = _animationStatus.animating;
        }
      });

    _animation = new Tween(
      begin: -pi / 2.0,
      end: 0.0,
    ).animate(new CurvedAnimation(
      parent: _animationController,
      curve: Curves.bounceOut,
      reverseCurve: Curves.bounceIn,
    ));

   
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  double rotationAngle = 0.0;
  bool profileopened = false;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print(user);
    MediaQueryData mediaquerydata = MediaQuery.of(context);
    double screenwidth = mediaquerydata.size.width;
    double screenheight = mediaquerydata.size.height;
    double angle = _animation.value;
    //double opacityval = _fadeinAnimation.value;
    //print(opacityval);
    if (loading == false) {
      return Scaffold(
          //backgroundColor: Color(0x040C0E),
          body: Stack(
        children: <Widget>[
          MainHome(user: user),
          Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButton(
                            onPressed: handleProfileOpenClose,
                            child: Text("My Profile"),
                          ),
                        ),
          Transform.rotate(
              angle: angle,
              origin: Offset(0.0, 0.0),
              alignment: Alignment.topLeft,
              child: Material(
                  color: Colors.transparent,
                  child: Container(
                      height: screenheight,
                      width: screenwidth,
                      color: Colors.amber[500],
                      child: Stack(children: <Widget>[
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Profile",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 50),
                              ),
                              ClipRRect(
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assests/91.gif',
                                  image: user.photo,
                                ),
                                borderRadius: BorderRadius.circular(150),
                              ),
                              SizedBox(height: 20.0),
                              Text(
                                user.name,
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: FlatButton(
                            onPressed: handleProfileOpenClose,
                            child: Text("Close"),
                          ),
                        )
                      ])))),
        ],
      ));
    } else {
      return Loading();
    }
  }
}

class MainHome extends StatefulWidget {
  const MainHome({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _MainHomeState createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> with TickerProviderStateMixin {
  AnimationController _fadeinAnimationController;
  Animation<double> _fadeinAnimation;

  @override
  void initState() {
    super.initState();
    _fadeinAnimationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 2000))
        ..addListener((){
          setState(() {
            
          });
        })..addStatusListener((AnimationStatus status){
          
        });

        
        

    _fadeinAnimation = Tween(begin: 0.0, end: 1.0).animate(new CurvedAnimation(
        curve: Curves.ease, parent: _fadeinAnimationController));

     _fadeinAnimationController.forward().orCancel;
  }
  

  @override
  Widget build(BuildContext context) {
    var fadeinAnimation = _fadeinAnimation;
    print(fadeinAnimation.value);
    bool loading =false;
    return loading==false? Container(
        color: Colors.amber[200].withOpacity(fadeinAnimation.value),
        //decoration:
        //  BoxDecoration(color: Colors.red.withOpacity(opacityval)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              
              Align(
                alignment: Alignment.center,
                child: FadeTransition(
                  opacity: fadeinAnimation,
                                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Hero(tag: "logo", child: Image.asset('assests/logo.png')),
                      SizedBox(height: 50),
                      RaisedButton(
                        onPressed: () async {
                          setState(() {
                              loading =true;
                            });
                          String roomkey = await createRoom(widget.user);
                          print("fromm homescreen");
                          
                          Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) {
                            print(roomkey);
                            
                            return Userloggedin(
                                child: CreateRoom(),
                                user: widget.user,
                                roomkey: roomkey);
                          }));
                        },
                        child: Text(
                          "Create Room",
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) {
                            return Userloggedin(
                                child: JoinRoom(user: widget.user),
                                user: widget.user);
                          }));
                        },
                        child: Text("Join Room"),
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
                        
                      ),
                      
                    ],
                  ),
                ),
              )
            ])):Loading();
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
