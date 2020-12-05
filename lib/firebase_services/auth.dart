import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth auth;

  Auth(this.auth);

  Stream<User> get authStateChanges => auth.authStateChanges();

  Future<String> createAccount({String email, String password}) async {
    try {
      final User firebaseUser = (await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      ))
          .user;
      if (firebaseUser != null) {
        //save in RTDB
        return "Success";
      } else {
        //error RTDB
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      rethrow;
    }
    return "Success";
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
