import 'User.dart';

class Room{
  final String roomid;
  final String owneruid;
  final List<dynamic> players;
  final bool hasGameStarted;
  

  Room({this.roomid,this.owneruid, this.players,this.hasGameStarted});
}