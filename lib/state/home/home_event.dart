part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeScreenStateChangeEvent extends HomeEvent {
  final ViewState viewState;

  HomeScreenStateChangeEvent(this.viewState);
}
//delete

class DeleteUserEvent extends HomeEvent {
  final int id;

  DeleteUserEvent({required this.id});
}

class FetchAllInitialDataEvent extends HomeEvent {}
//update

class UpdateUserEvent extends HomeEvent {
  final UserModel  user;

  UpdateUserEvent({required this.user});
}

class AddUserEvent extends HomeEvent {
  final UserModel  user;

  AddUserEvent({required this.user});
}
class UserLogoutEvent extends HomeEvent{}