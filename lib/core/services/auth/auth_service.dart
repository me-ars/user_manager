import 'package:user_manager/core/services/database_service.dart';
import 'package:user_manager/core/services/network_service.dart';
import 'package:user_manager/models/logged_user.dart';

class AuthService {
  final NetworkService _networkService = NetworkService();
  final DatabaseService _databaseService = DatabaseService();

  Future<LoggedUser?> login({
    required String userName,
    required String password,
  }) async {
    try {
      Map<String, dynamic> loginMap = {
        "email": userName,
        "password": password,
      };
      var response = await _networkService.postData(
        endpoint: 'login',
        body: loginMap,
      );

      if (response.containsKey("token")) {
        final user = LoggedUser(
          username: userName,
          password: password,
          token: response["token"],
        );
        await _databaseService.saveLoggedUser(user: user);
        return user;
      }

      if (response["error"] == true) {
        throw Exception(response["message"] ?? "Login failed");
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }
  Future<void> logout() async {
    try {
      await _databaseService.clearLoggedUser();
    } catch (e) {
      throw Exception("Logout failed: ${e.toString()}");
    }
  }

}
