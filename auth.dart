import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential ucr =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("USER CREATED: ${ucr.user?.uid}");

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print("SIGNUP ERROR: ${e.code}");

      if (e.code == 'weak-password') {
        return 'Password is too weak';
      } else if (e.code == 'email-already-in-use') {
        return 'Email already exists';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email';
      }

      return e.code;
    } catch (e) {
      print("UNKNOWN SIGNUP ERROR: $e");
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print("LOGIN SUCCESS");

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print("LOGIN ERROR CODE: ${e.code}");

      if (e.code == 'user-not-found') {
        return 'No user found for this email';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password';
      } else if (e.code == 'invalid-email') {
        return 'Invalid email format';
      }

      return e.code;
    } catch (e) {
      print("UNKNOWN LOGIN ERROR: $e");
      return e.toString();
    }
  }

  Future<String?> forgotPass({
    required String email,
  }) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      return 'Success';
    } on FirebaseAuthException catch (e) {
      print("RESET PASSWORD ERROR: ${e.code}");

      if (e.code == 'user-not-found') {
        return 'No user found for this email';
      }

      return e.code;
    } catch (e) {
      return e.toString();
    }
  }
}