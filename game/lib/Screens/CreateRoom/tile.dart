import 'package:flutter/material.dart';

class Tile extends StatelessWidget {
  final String name;
  final String photo;
  
  Tile({this.name, this.photo});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
      child: ListTile(
          title: Text(name),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(photo),
          ),
          ),
    );
  }
}
