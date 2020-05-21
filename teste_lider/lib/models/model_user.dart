import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class User extends Model {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser firebaseUser;
  Map<String, dynamic> userData = Map();

  bool isloading = false;

  void signUp(
      {@required Map<String, dynamic> userData,
      @required String pass,
      @required VoidCallback onSuccess,
      @required VoidCallback onFail}) {
    isloading = true;
    notifyListeners();
    _auth
        .createUserWithEmailAndPassword(
            email: userData['email'], password: pass)
        .then((authResult) async {
      firebaseUser = authResult.user;
      await _saveUserData(userData);
      onSuccess();
      isloading = false;
      notifyListeners();
      return firebaseUser.uid;
    }).catchError((e) {
      onFail();
      isloading = false;
      notifyListeners();
    });
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    this.userData = userData;
    await Firestore.instance
        .collection('users')
        .document(firebaseUser.uid)
        .setData(userData);
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut();
    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  //var snapshot= Firestore.instance.collection('users').document().get();
  //User user = User.fromJson()

  //static fromJson(Map<String,dynamic>parsedJson){
  // return User(
  //  apelido: parsedJson['apelido'],
  // nome: parsedJson['nome'],
  // sobrenome : parsedJson['sobrenome'],
  // email: parsedJson['email']
  // );
  // }
//    Firestore db = Firestore.instance;
  //  DocumentSnapshot snapshot =
  //    await db.collection('users').document(firebaseUser.uid).get();
  //var dados = snapshot.data;

  User(
      {this.uid,
      this.apelido,
      this.nome,
      this.sobrenome,
      this.email,
      this.password});

  String uid;
  String apelido;
  String nome;
  String sobrenome;
  String email;
  String password;
}
