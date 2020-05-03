import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:game/Models/User.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Authentication {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  //converting firebase user object to custom user object
  User _userfromfirebase(FirebaseUser user) {
    return user != null ? User(uid: user.uid ,name: user.displayName,photo: user.photoUrl) : null;
  }

  //Sign in with google
  Future<User> signinwithgoogle() async {
    try {
      final googleuser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleuser.authentication;
      final AuthCredential credentials = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      final AuthResult authResult =
          await _auth.signInWithCredential(credentials);
      final FirebaseUser user = authResult.user;
      
      await insertintouserscollection(user);

      return _userfromfirebase(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  
  
  //Signout with google
  Future signoutwithgoogle() async {
    await googleSignIn.signOut();
    await _auth.signOut();
    print('hey');
    

  }
//to track changes in user stream
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userfromfirebase);
  }

//insert into users Collection 

  Future insertintouserscollection (FirebaseUser user) async {
    final CollectionReference userCollection =
      Firestore.instance.collection('users');
    await userCollection.document(user.uid).setData({
      'uid':user.uid,
      'name':user.displayName,
      'photo_url':user.photoUrl,
    });

  }
}
