import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? _user;
  User? get currentUser => _user;

  AuthProvider() {
    _auth.authStateChanges().listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }

  // Google Authentication method
  Future<String?> loginWithGoogle() async {
    try {
      // Initialize GoogleSignIn without autoSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId: "227424076654-n0pitktmor0h8r2d9nc8nf592fao66o6.apps.googleusercontent.com", // Your Web Client ID here
      );

      // Trigger the Google sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return 'Google sign-in aborted';
      }

      // Obtain the authentication details from the Google user
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      await _auth.signInWithCredential(credential);

      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }

  // Logout method: Sign out from both Firebase and Google
  Future<void> logout() async {
    try {
      // Sign out from Firebase
      await _auth.signOut();
      
      // Sign out from Google
      await _googleSignIn.signOut();

      _user = null; // Clear the current user
      notifyListeners();
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  Future<String?> loginAsGuest() async {
    try {
      final userCredential = await _auth.signInAnonymously();
      return null; // No error
    } on FirebaseAuthException catch (e) {
      return e.message; // Return error message
    }
  }
}
