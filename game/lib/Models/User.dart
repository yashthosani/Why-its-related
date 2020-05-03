class User{
  final String name ;
  final String uid;
  final String photo;
  User({this.name, this.uid,this.photo});

  Map<String,dynamic> toJson()=>
{
    'name': name,
    'uid': uid,
    'photo':photo,
  };


}