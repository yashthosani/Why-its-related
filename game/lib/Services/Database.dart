import 'dart:async';

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game/Models/User.dart';
import 'package:game/Models/Room.dart';
import 'package:game/Models/playersData.dart';

Future<String> createRoom(User user) async {
  try {
    final CollectionReference roomCollection =
        Firestore.instance.collection('rooms');
    List m = [user.toJson()];
    print(m);

    var roomkeygenerator = Random.secure();
    int roomKey = 100000 + roomkeygenerator.nextInt(999999);

    await roomCollection.document(roomKey.toString()).setData({
      'owner-uid': user.uid,
      'room-key': roomKey.toString(),
      'players': m,
      'game Started': false,
    });
    return (roomKey.toString());
  } catch (e) {
    return (null);
  }
}

Future<String> joinroom(User user, String roomkey) async {
  try {
    final CollectionReference room = Firestore.instance.collection('rooms');

    await room.document(roomkey).updateData({
      "players": FieldValue.arrayUnion([user.toJson()])
    });

    return (roomkey);
  } catch (e) {
    return (null);
  }
}

User mapPlayerstousers(var player) {
  return (User(
      name: player['name'], uid: player['uid'], photo: player['photo']));
}

Room maptoroomclass(DocumentSnapshot room) {
  print("from map class");
  print(room.data['players'].map((player) {
    print(player['name']);
  }));

  try {
    return (Room(
        owneruid: room.data['owner-uid'],
        players: room.data['players'].map(mapPlayerstousers).toList(),
        roomid: room.data['room-key'],
        hasGameStarted: room.data['game Started']));
  } catch (e) {
    print(e.toString());
  }
}

Stream<Room> roomdata(String roomKey) {
//print(roomKey);
  var m = Firestore.instance
      .collection('rooms')
      .document(roomKey)
      .snapshots()
      .map(maptoroomclass);

  print("hello");
  print(m);
  return m;
}

//var m = roomdata('erre').listen(print);

Future createRound(
    int roundNumber, String roomKey, List<dynamic> players) async {
  try {
    WriteBatch batch = Firestore.instance.batch();
    CollectionReference collref = Firestore.instance
        .collection('rooms')
        .document(roomKey)
        .collection('rounds')
        .document(roundNumber.toString())
        .collection('player-data');

    for (var i = 0; i < players.length; i++) {
      print("from create round");
      print(players[i].name);
      print(roomKey);
      print(roundNumber);
      DocumentReference docref = collref.document(players[i].uid);
      if ((i + 1) == roundNumber) {
        batch.setData(docref, {
          'player': players[i].toJson(),
          'word': '',
          'response': '',
          'role': 'master',
          'points': 0,
        });
      } else {
        batch.setData(docref, {
          'player': players[i].toJson(),
          'word': '',
          'response': '',
          'role': 'player',
          'points': 0,
        });
      }
      print("object");
      print(batch);
    }
    batch.commit().catchError((e) {
      print(e.toString());
      print('there some problem');
    });
  } catch (e) {
    print(e.toString());
  }
}

Future addword(
    String roomKey, String roundNumber, String word, String userid) async {
  print(roomKey);
  print(roundNumber);
  print(word);
  try {
    await Firestore.instance
        .collection('rooms')
        .document(roomKey)
        .collection('rounds')
        .document(roundNumber.toString())
        .collection('player-data')
        .document(userid)
        .updateData({"word": word});
  } catch (e) {
    print(e.toString());
  }
}

Future addResponse(
    String roomKey, String roundNumber, String response, String userid) async {
  print(roomKey);
  print(roundNumber);
  print(response);
  try {
    await Firestore.instance
        .collection('rooms')
        .document(roomKey)
        .collection('rounds')
        .document(roundNumber.toString())
        .collection('player-data')
        .document(userid)
        .updateData({"response": response});
  } catch (e) {
    print(e.toString());
  }
}

List<playersData> maptoPlayerData(QuerySnapshot snapshot) {
  return snapshot.documents.map((doc) {
    return playersData(
        doc.documentID,
        doc.data['role'],
        doc.data['word'],
        doc.data['response'],
        doc.data['player'],
        doc.data['roundFinished'],
        doc.data['points']);
  }).toList();
}

Stream<List<playersData>> playerdata(String roomKey, String roundNo) {
//print(roomKey);

  var m = Firestore.instance
      .collection('rooms')
      .document(roomKey)
      .collection('rounds')
      .document(roundNo.toString())
      .collection('player-data')
      .snapshots()
      .map(maptoPlayerData);

  print(m);
  return m;
}

Future finishRoundandStartNewRound(
    String roomKey, String roundNo, String roomOwneruid) async {
  await Firestore.instance
      .collection('rooms')
      .document(roomKey)
      .collection('rounds')
      .document(roundNo.toString())
      .collection('player-data')
      .document(roomOwneruid)
      .updateData({"roundFinished": true});
}

Future addPoints(String roomKey, String roundNo, Map winner) async {
  print(winner);
  await Firestore.instance
      .collection('rooms')
      .document(roomKey)
      .collection('rounds')
      .document(roundNo.toString())
      .collection('player-data')
      .document(winner['uid'])
      .updateData({"points": FieldValue.increment(10)});

  await Firestore.instance
      .collection('rooms')
      .document(roomKey)
      .collection('rounds')
      .document(roundNo.toString())
      .setData({"winner": winner});
}

//Final screen
Future<Map> getResults(String roomKey) async {
  var res = await Firestore.instance
      .collection('rooms')
      .document(roomKey)
      .collection('rounds')
      .getDocuments();

  var finalResults = Map();
  print("getresults");
  print("(()()()()()()()()()()()()()()())");
  //print(res.documentID);
  print(res.documents);

  res.documents.forEach((DocumentSnapshot element) {
    User player = User(
          name: element.data['winner']['name'],
          uid: element.data['winner']['uid'],
          photo: element.data['winner']['photo']);
    if (!finalResults.containsKey(element.data['winner'])) {
      print(":::::::::::::::::::::::::::::::::::");
      print(element.data['winner']['uid']);
      
      finalResults[player.uid] = 10;
    } else {
      finalResults[player.uid] += 10;
    }
  });

  return (finalResults);
}
