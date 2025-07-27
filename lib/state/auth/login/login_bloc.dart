import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:user_manager/core/enums/view_state.dart';
import 'package:user_manager/core/services/database_service.dart';
import 'package:user_manager/models/logged_user.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  ViewState loginViewState = ViewState.idealState;

  LoginBloc() : super(LoginInitial()) {
    // Handle initial load
    on<LoginInitialEvent>((event, emit) {
      emit(LoginInitialLoadState(isLogged: false));
    });

    // Handle view state changes
    on<LoginScreenStateChangeEvent>((event, emit) {
      emit(LoginViewStateChangeState(viewState: event.viewState));
    });

    // Handle login event
    on<UserLoginEvent>((event, emit) async {
      emit(LoginViewStateChangeState(viewState: ViewState.loading));
      try {
        LoggedUser user = LoggedUser(
            username: event.userName, password: event.password);
        await DatabaseService().saveLoggedUser(user: user);
        var result =await DatabaseService().getLoggedUser();
        emit(UserLoginState());
        print(result);
      } catch (e) {
        emit(LoginViewStateChangeState(viewState: ViewState.error));
      }
    });

    // Handle login failure
    on<LoginValidationFailEvent>((event, emit) {
      emit(LoginValidationFailState(message: event.validationMessage));
    });
  }
}
