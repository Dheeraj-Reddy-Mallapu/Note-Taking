import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restart_app/restart_app.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googeleSignIn = GoogleSignIn();

  final firebaseAuth = FirebaseAuth.instance;

  GoogleSignInAccount? _user;
  GoogleSignInAccount get user => _user!;

  Future googleLogin() async {
    final googelUser = await googeleSignIn.signIn();
    if (googelUser == null) return;
    _user = googelUser;

    final googleAuth = await googelUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    await firebaseAuth.signInWithCredential(credential);

    notifyListeners();
  }

  Future googleLogout() async {
    await firebaseAuth.signOut();
    _user = null;
    notifyListeners();

    Future.delayed(Durations.extralong1, () async => await Restart.restartApp());
  }
}
