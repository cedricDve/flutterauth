import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;
  //constructor: named-parameter ->{}
  Auth({this.auth});
  // User -> FirebaseUser
  Stream<User> get user => auth.authStateChanges();
  User get currentUser => auth.currentUser;

  Future<String> createAccount({String email, String password}) async {
    try {
      await auth.createUserWithEmailAndPassword(
        //trim will hide the withspaces if the users enters a space
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signIn({String email, String password}) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> signOut() async {
    try {
      await auth.signOut();
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
  }
}
