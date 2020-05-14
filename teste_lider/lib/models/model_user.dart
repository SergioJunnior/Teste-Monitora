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

  bool isLoggedIn() {
    return firebaseUser != null;
  }

  void signIn({
    @required String email,
    @required String password,
  }) async {
    isloading = true;
    notifyListeners();
    _auth
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authResult) async {
      firebaseUser = authResult.user;
      await loadCurrentUser();
      isloading = false;
      notifyListeners();
      isloading = false;
      notifyListeners();
    });
  }

  Future<Null> loadCurrentUser() async {
    if (firebaseUser == null)
      firebaseUser = await FirebaseAuth.instance.currentUser();
    if (firebaseUser != null) {
      if (userData == null) {
        DocumentSnapshot docUser = await Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }

  void showData() async {
    await loadCurrentUser();
  }

  void signOut() async {
    await _auth.signOut();
    userData = Map();
    firebaseUser = null;

    notifyListeners();
  }

  User({this.apelido, this.nome, this.sobrenome, this.email, this.password});

  String apelido;
  String nome;
  String sobrenome;
  String email;
  String password;
}
