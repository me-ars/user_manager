part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

class HomeViewStateChangeState extends HomeState {
  final ViewState viewState;

  HomeViewStateChangeState({required this.viewState});
}

class HomeInitialFetchSuccessState extends HomeState {
  final List<UserModel> users;
  final LoggedUser currentUser;

  HomeInitialFetchSuccessState({
    required this.users,
    required this.currentUser,
  });
}

class UserUpdateSuccessState extends HomeState {
  final List<UserModel> users;
  final LoggedUser currentUser;

  UserUpdateSuccessState({
    required this.users,
    required this.currentUser,
  });
}
class UserLogoutState extends HomeState{}
