import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_manager/core/services/auth/auth_service.dart';
import 'package:user_manager/core/services/database_service.dart';
import 'package:user_manager/models/logged_user.dart';

import '../../core/enums/view_state.dart';
import '../../core/services/network_service.dart';
import '../../models/user_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final NetworkService _networkService = NetworkService();
  final AuthService _authService = AuthService();
  List<UserModel> _users = [];
  LoggedUser? _currentUser;

  List<UserModel> get users => _users;

  LoggedUser? get currentUser => _currentUser;

  HomeBloc() : super(HomeInitial()) {
    on<FetchAllInitialDataEvent>(_onFetchAllInitialData);
    on<UpdateUserEvent>(_updateUser);
    on<DeleteUserEvent>(_deleteUser);
    on<AddUserEvent>(_addUserEvent);
    on<UserLogoutEvent>(_logoutUser);
  }

//fetch the users and current user at the initial stage
  Future<void> _onFetchAllInitialData(
      FetchAllInitialDataEvent event, Emitter<HomeState> emit) async {
    emit(HomeViewStateChangeState(viewState: ViewState.loading));
    try {
      final usersResponse = await _networkService.getData("users?page=1");
      _users = usersResponse
          .map<UserModel>((json) => UserModel.fromJson(json))
          .toList();
      LoggedUser? user =  DatabaseService().getLoggedUser();
      _currentUser =
          LoggedUser(username: user!.username, password: user.username, token: user.token);

      emit(HomeInitialFetchSuccessState(
          users: _users, currentUser: _currentUser!));
    } catch (e) {
      emit(HomeViewStateChangeState(viewState: ViewState.error));
    }
  }

  FutureOr<void> _updateUser(
      UpdateUserEvent event, Emitter<HomeState> emit) async {
    emit(HomeViewStateChangeState(viewState: ViewState.loading));
    try {
      _users = _users.map((user) {
        // If it's the user to be updated, return the new updated version
        if (user.id == event.user.id) return event.user;
        return user;
      }).toList();

      emit(UserUpdateSuccessState(
        users: List<UserModel>.from(_users), // emit new list
        currentUser: _currentUser!,
      ));
    } catch (e) {
      emit(HomeViewStateChangeState(viewState: ViewState.error));
    }
  }

  FutureOr<void> _deleteUser(
      DeleteUserEvent event, Emitter<HomeState> emit) async {
    emit(HomeViewStateChangeState(viewState: ViewState.loading));
    try {
      await _networkService.deleteData(
          endpoint: "users", id: event.id.toString());
      _users.removeWhere((user) => user.id == event.id);
      emit(UserUpdateSuccessState(users: _users, currentUser: _currentUser!));
    } catch (e) {
      emit(HomeViewStateChangeState(viewState: ViewState.error));
    }
  }

  FutureOr<void> _addUserEvent(
      AddUserEvent event, Emitter<HomeState> emit) async {
    emit(HomeViewStateChangeState(viewState: ViewState.loading));
    try {
      await _networkService.addData("users", event.user.toJson());
      _users.add(event.user.copyWith(id: _users.length + 1));
      emit(UserUpdateSuccessState(users: _users, currentUser: _currentUser!));
    } catch (e) {
      emit(HomeViewStateChangeState(viewState: ViewState.error));
    }
  }

  FutureOr<void> _logoutUser(UserLogoutEvent event, Emitter<HomeState> emit) async{
    emit(HomeViewStateChangeState(viewState: ViewState.loading));
    try {
      await _authService.logout();
      emit(UserLogoutState());
    } catch (e) {
      emit(HomeViewStateChangeState(viewState: ViewState.error));
    }
  }
}
