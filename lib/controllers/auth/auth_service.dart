import 'package:citybusters/controllers/auth/auth_res.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';

class AuthService {
  // LOCAL SIGN IN
  // Success -> AuthResult.SuccessfulSignIn
  // Not Success -> AuthResult.Error
  static Future<AuthResult> localSignIn(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user == null) return AuthResult.Error;
    } on FirebaseAuthException catch (_) {
      return AuthResult.Error;
    } on PlatformException catch (_) {
      return AuthResult.Error;
    } catch (error) {
      return AuthResult.Error;
    }

    if (FirebaseAuth.instance.currentUser != null) {
      return AuthResult.SuccessfulLoginIn;
    } else {
      return AuthResult.Error;
    }
  }

  // LOCAL SIGN UP
  // Success -> AuthResult.SuccessfulLocalSignUp
  // User Already Exists -> AuthResult.UserExists
  // Not Success -> AuthResult.Error
  static Future<AuthResult> localSignUp(
    String email,
    String password,
    String name,
  ) async {
    UserCredential userCredential;
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);
    } on FirebaseAuthException catch (_) {
      return AuthResult.Error;
    } catch (error) {
      return AuthResult.Error;
    }

    if (userCredential.additionalUserInfo == null) return AuthResult.Error;
    if (!userCredential.additionalUserInfo!.isNewUser)
      return AuthResult.UserExists;

    if (userCredential.user == null) return AuthResult.Error;

    // create in server

    return AuthResult.SuccessfulSignUp;
  }
}
