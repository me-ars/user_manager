class LoginValueValidator {
  static bool isValidEmail({required String email}) {
    return RegExp(
        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
    ).hasMatch(email);
  }

  static bool isValidPassword({required String password}) {
    return password.length == 6 && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(password);
  }
}
