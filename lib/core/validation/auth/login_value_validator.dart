class LoginValueValidator {
  static bool isValidEmail({required String email}) {
    return RegExp(
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+$"
    ).hasMatch(email);
  }
  static bool isValidPassword({required String password}) {
    return password.length <= 15 &&
        RegExp(r'^[a-zA-Z0-9]+$').hasMatch(password);
  }
}
