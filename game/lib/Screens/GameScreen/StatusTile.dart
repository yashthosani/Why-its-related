import 'package:flutter/material.dart';

class StatusTile extends StatelessWidget {
  final String name;
  final String photo;
  final bool status;
  
  StatusTile({this.name, this.photo,this.status});
  var colour=Colors.grey;
  @override
  Widget build(BuildContext context) {
    print("from card");
    print(status);

    if(status==true){
      colour =Colors.green;
    }
    else{

      colour =Colors.grey;
    }
    return Card(
      margin: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
      child: ListTile(
          title: Text(name),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(photo),
          ),
          trailing: Icon(Icons.check_circle_outline,color:colour,size: 30.0, ),
          ),
    );
  }
}
