// to get data
import 'package:firebase_auth/firebase_auth.dart';

abstract class AccountViewModel {
  Future<FirebaseUser> getCurrentUser();

  Future<String> signInWithGoogle();

  Future<void> signOutGoogle();
}
