import 'package:flutter/material.dart';
import 'package:user_manager/core/services/database_service.dart';
import 'core/app/user_manager.dart';
import 'models/logged_user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseService().init();
  LoggedUser? currentUser = await _getCurrentUser();

  runApp(UserManager(
    isLggedIn: currentUser != null,
  ));
}

Future<LoggedUser?> _getCurrentUser() async {
  LoggedUser? currentUser =  DatabaseService().getLoggedUser();
  return currentUser;
}
