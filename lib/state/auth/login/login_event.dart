part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginScreenStateChangeEvent extends LoginEvent {
  final ViewState viewState;

  LoginScreenStateChangeEvent(this.viewState);
}

class UserLoginEvent extends LoginEvent {
  final String userName;
  final String password;

  UserLoginEvent({required this.password, required this.userName});
}

class LoginValidationFailEvent extends LoginEvent {
  String? validationMessage;
  LoginValidationFailEvent({required this.validationMessage});
}

