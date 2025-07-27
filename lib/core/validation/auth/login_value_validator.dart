class LoginValueValidator {
  static bool isValidUsername({required String username}) {
    return username.length == 6 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username);
  }

  static bool isValidPassword({required String password}) {
    return password.length == 6 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(password);
  }
}
