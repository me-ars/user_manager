part of 'login_bloc.dart';

@immutable
sealed class LoginEvent {}

class LoginInitialEvent extends LoginEvent {}

class LoginScreenStateChangeEvent extends LoginEvent {
  final ViewState viewState;

  LoginScreenStateChangeEvent(this.viewState);
}

class UserLoginEvent extends LoginEvent {
  final String email;
  final String password;

  UserLoginEvent({required this.password, required this.email});
}

class LoginValidationFailEvent extends LoginEvent {
  String? validationMessage;
  LoginValidationFailEvent({required this.validationMessage});
}

