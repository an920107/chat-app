import 'dart:async';

import 'package:chat_app/model/user.dart';
import 'package:chat_app/repo/local/user_local_repo.dart';
import 'package:chat_app/repo/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter/material.dart';

class SignInPageViewModel with ChangeNotifier {
  bool get isSignedIn => FirebaseAuth.instance.currentUser != null;

  SignInPageContentType _type = SignInPageContentType.signIn;
  SignInPageContentType get type => _type;
  set type(SignInPageContentType value) {
    _type = value;
    notifyListeners();
  }

  void changeType() {
    type = type == SignInPageContentType.signIn
        ? SignInPageContentType.registration
        : SignInPageContentType.signIn;
    notifyListeners();
  }

  /// Create a new account with Firebase Auth, It returns the error message if a
  /// [FirebaseAuthException] raised, otherwise return null.
  Future<String?> createAccount(
      String email, String password, String name) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = User(
        id: credential.user!.uid,
        name: name,
        email: credential.user!.email!,
        createdTime: DateTime.now().toUtc(),
        updatedTime: DateTime.now().toUtc(),
      );
      await UserLocalRepo.createUser(user);
      await UserRemoteRepo().createUser(user);
    } on FirebaseAuthException catch (e) {
      return "${e.code}: ${e.message}";
    }
    _type = SignInPageContentType.signIn;
    return null;
  }

  /// Sign in with Firebase Auth, It returns the error message if a
  /// [FirebaseAuthException] raised, otherwise return null.
  Future<String?> signIn(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      return "${e.code}: ${e.message}";
    }
    return null;
  }

  String? emailValidation(String? email) {
    if (email?.trim().isEmpty ?? true) {
      return "Email can't be empty";
    }
    if (!email!.contains("@")) {
      return "Email is not valid";
    }
    return null;
  }

  String? passwordValidation(String? password) {
    if (password?.trim().isEmpty ?? true) {
      return "Password can't be empty";
    }
    if (password!.length < 6) {
      return "Password must be at least 6 characters long";
    }
    return null;
  }

  String? nameValidation(String? name) {
    if (name?.trim().isEmpty ?? true) {
      return "Name can't be empty";
    }
    return null;
  }
}

enum SignInPageContentType {
  signIn,
  registration;
}
