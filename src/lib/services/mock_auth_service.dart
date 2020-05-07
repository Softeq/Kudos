import 'package:kudosapp/models/user.dart';
import 'package:kudosapp/services/base_auth_service.dart';

class MockAuthService extends BaseAuthService {
  @override
  User get currentUser => User(
    id: "test_id",
    name: "Test Name",
    email: "test.name@softeq.com",
    photoUrl: "https://via.placeholder.com/150",
  );

  @override
  Future<void> signIn() {
    return null;
  }

  @override
  Future<void> signOut() {
    return null;
  }

  @override
  void silentInit(callback) {
    callback(currentUser);
  }
}