part of 'login_bloc.dart';

@immutable
sealed class LoginState {}

final class LoginInitial extends LoginState {}

class LoginInitialLoadState extends LoginState {
  final bool isLogged;

  LoginInitialLoadState({required this.isLogged});
}

class LoginViewStateChangeState extends LoginState {
  final ViewState viewState;

  LoginViewStateChangeState({required this.viewState});
}

class LoginValidationFailState extends LoginState {
  final String? message;

  LoginValidationFailState({required this.message});
}

class UserLoginState extends LoginState {}
