import 'package:google_sign_in/google_sign_in.dart';
import 'package:kudosapp/models/user.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'https://www.googleapis.com/auth/contacts.readonly',
    ],
  );

  GoogleSignInAccount _account;
  User _currentUser;

  User get currentUser => _currentUser;
  Future<Map<String, String>> get authHeaders => _account.authHeaders;

  // TODO YP: another way
  GoogleUserCircleAvatar get avatarView {
    return GoogleUserCircleAvatar(
      identity: _account,
    );
  }

  void silentInit(callback) {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _account = account;
      _currentUser =
          account == null ? null : User(account.displayName, account.email);
      callback(_currentUser);
    });
    _googleSignIn.signInSilently();
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  Future<void> signOut() => _googleSignIn.disconnect();
}
