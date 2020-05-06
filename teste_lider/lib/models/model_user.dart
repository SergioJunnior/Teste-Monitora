import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  User({this.apelido, this.nome, this.sobrenome, this.email, this.password});

  String apelido;
  String nome;
  String sobrenome;
  String email;
  String password;
}
