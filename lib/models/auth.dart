import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {

  Future<String> currentUser();
  Future<String> signIn(String email, String password);
  Future<String> createUser(String email, String password);
  Future<void> signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> signIn(String email, String password) async {
    UserCredential result= await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    User user = result.user!;
    return user.uid;
  }

  Future<String> createUser(String email, String password) async {
    UserCredential result= await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
    User user = result.user!;
    return user.uid;
  }

  Future<String> currentUser() async {
    User result =  FirebaseAuth.instance.currentUser!;
    return  result.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

}