import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class AuthService extends ChangeNotifier {
  final googleSignIn = GoogleSignIn();

  GoogleSignInAccount _user;

  Future googleLogin() async {
    try {
      final googleUser = await googleSignIn.signIn();

      if (googleUser == null) return;
      _user = googleUser;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
      print('---------------**********************---------------------');

      dynamic f = await FirebaseAuth.instance.signInWithCredential(credential);
      print(f.user);
      notifyListeners();
    } on Exception catch (error) {
      print(error.toString());
    }
  }
}
