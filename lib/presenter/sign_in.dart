import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn googleSignIn = GoogleSignIn();

//use the Google sign-in data to authenticate a FirebaseUser
//return that user
Future<String> signInWithGoogle() async {
  final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken);

  //google
  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  String tokenGoogle;
  await user.getIdToken().then((value) => tokenGoogle = value.token);

  //firebase
  final FirebaseUser currentUser = await _auth.currentUser();
  String tokenFirebase;
  await currentUser.getIdToken().then((value) => tokenFirebase = value.token);

  if (currentUser != null) {
    print('Google:' + tokenGoogle);
    print('Firebase:' + tokenFirebase);

    print('signInWithGoogle succeeded: $currentUser');

    return '$currentUser';
  }

  return null;
}

//sign out of the current Google account
Future<void> signOutGoogle() async {
  await _auth.signOut();
  await googleSignIn.signOut();

  print("User Signed Out");
}
