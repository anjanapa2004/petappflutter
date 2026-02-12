import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthServiceprovider with ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges =>
      _firebaseAuth.authStateChanges();

  // 🔄 Email auth loading
  bool isLoading = false;
  void setLoading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  // Register
Future<String> createUserWithEmailAndPassword({
  required String email,
  required String password,
}) async {
  try {
    isLoading = true;
    notifyListeners();

    final userCredential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user!.uid;
  } finally {
    isLoading = false;
    notifyListeners();
  }
}


  // Login
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      setLoading(true);
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    } finally {
      setLoading(false);
    }
  }

  // Logout
  Future<void> logout() async {
    await _firebaseAuth.signOut();
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {}
  }

  // Google Sign-In
  bool isGoogleLoginLoading = false;
  void setGoogleLoginLoading(bool val) {
    isGoogleLoginLoading = val;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    try {
      setGoogleLoginLoading(true);

      final googleUser = await GoogleSignIn.instance.authenticate();
      final auth = await GoogleSignIn.instance.authorizationClient
          .authorizationForScopes(["email"]);

      final credential = GoogleAuthProvider.credential(
        accessToken: auth?.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      await _firebaseAuth.signInWithCredential(credential);
      log("Google login successful");
    } catch (e) {
      log("Google login error: $e");
      rethrow;
    } finally {
      setGoogleLoginLoading(false);
    }
  }
}
