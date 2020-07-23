import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kudosapp/models/errors/auth_error.dart';
import 'package:kudosapp/models/user_model.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class AuthService extends BaseAuthService {
  final _googleSignIn = GoogleSignIn(scopes: ['email']);
  final _firebaseAuth = FirebaseAuth.instance;

  UserModel _currentUser;

  @override
  UserModel get currentUser => _currentUser;

  @override
  void silentInit(Function(UserModel) userChangedHandler) {
    _firebaseAuth.onAuthStateChanged.listen((FirebaseUser firebaseUser) {
      _currentUser = firebaseUser == null
          ? null
          : UserModel.createNew(
              firebaseUser.displayName,
              firebaseUser.email,
              firebaseUser.photoUrl,
            );
      userChangedHandler(_currentUser);
    });
  }

  @override
  Future<void> signIn() async {
    try {
      final googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw new AuthError('User skip the authorization', null);
      }
      if (!_validateEmail(googleUser.email)) {
        _googleSignIn.disconnect();
        throw new AuthError('Available only for @softeq.com members!', null);
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on PlatformException catch (error) {
      throw new AuthError(error.message, null);
    } catch (error) {
      throw new AuthError('Error during sign-in', error);
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  bool _validateEmail(String email) {
    return email.endsWith("@softeq.com");
  }
}
