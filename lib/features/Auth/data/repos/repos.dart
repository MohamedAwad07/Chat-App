import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthService {
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  });
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  });
  Future<void> loginWithGoogle();
  Future<UserCredential> loginWithFacebook();
  Future<void> logout();
  Future<void> resetPassword({
    required String email,
  });
}

class AuthServiceImpl implements AuthService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  AuthServiceImpl({required this.auth, required this.firestore});

  @override
  Future<void> registerWithEmailAndPassword({
    required String email,
    required String password,
    required String username,
  }) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;
      await firestore.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'createdAt': Timestamp.now().millisecondsSinceEpoch,
      });

      log("User registered successfully!");
    } catch (e) {
      log("Error during registration: $e");
      rethrow;
    }
  }

  @override
  Future<UserCredential> loginWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log("User logged in successfully!");
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        log('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        log('Wrong password provided for that user.');
      }
      rethrow;
    }
  }

  @override
  Future<UserCredential> loginWithFacebook() async {
    final FacebookAuthProvider facebookProvider = FacebookAuthProvider();
    return await auth.signInWithProvider(facebookProvider);
  }

  @override
  Future<void> loginWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
      clientId: dotenv.env['GOOGLE_CLIENT_ID'],
    );
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      log('Google sign-in successful');
      await auth.signInWithCredential(credential);
    } else {
      log('Google sign-in failed');
    }
  }

  @override
  Future<void> logout() async {
    log('User logged out');
    return await auth.signOut();
  }

  @override
  Future<void> resetPassword({required String email}) async {
    log('Password reset email sent');
    return await auth.sendPasswordResetEmail(email: email);
  }
}
