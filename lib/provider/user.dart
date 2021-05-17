import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userNotifierProvider =
    ChangeNotifierProvider.autoDispose((ref) => UserNotifier());

class UserNotifier extends ChangeNotifier {
  User? user;

  Future<void> signInAnonymously() async {
    final userCredential = await FirebaseAuth.instance.signInAnonymously();
    user = userCredential.user;
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    final googleProvider = GoogleAuthProvider();
    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');

    final userCredential =
        await FirebaseAuth.instance.signInWithPopup(googleProvider);
    user = userCredential.user;
    notifyListeners();
  }
}
