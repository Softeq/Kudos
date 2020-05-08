import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kudosapp/core/errors/auth_error.dart';
import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class AuthService extends BaseAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  FirebaseUser _firebaseUser;
  User _currentUser;

  @override
  User get currentUser => _currentUser;

  @override
  void silentInit(callback) {
    _firebaseAuth.onAuthStateChanged.listen((FirebaseUser firebaseUser) {
      _firebaseUser = firebaseUser;
      _currentUser = firebaseUser == null
        ? null
        : User(
          id: null,
          name: firebaseUser.displayName,
          email: firebaseUser.email,
          photoUrl: firebaseUser.photoUrl,
        );
      callback(_currentUser);
    });
  }

  @override
  Future<void> signIn() async {
    try {
      final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw new AuthError('User skip the authorization', null);
      }
      if (!_validateEmail(googleUser.email)) {
        _googleSignIn.disconnect();
        throw new AuthError('Available for Softeq members only!', null);
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.getCredential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await _firebaseAuth.signInWithCredential(credential);
    } on PlatformException catch(error) {
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
    const List<String> allowedDomains = [
      'softeq.com',
      'softeq.by',
      'zgames.com',
    ];
    var domainOfEmail = email.split('@').last;
    return allowedDomains.contains(domainOfEmail);
  }
}
