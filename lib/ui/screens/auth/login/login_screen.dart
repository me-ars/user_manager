import 'package:flutter/material.dart';
import 'package:user_manager/core/validation/auth/login_value_validator.dart';
import 'package:user_manager/shared_widgets/custom_text_field.dart';
import 'package:user_manager/state/auth/login/login_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_manager/ui/screens/home/home_screen.dart';
import '../../../../core/enums/view_state.dart';
import '../../../../core/theme/app_palete.dart';
import '../../../../shared_widgets/custom_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: const _LoginScreenView(),
    );
  }
}

//text controller initialization  for user inputs
final TextEditingController userNameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

class _LoginScreenView extends StatefulWidget {
  const _LoginScreenView();

  @override
  State<_LoginScreenView> createState() => _LoginScreenViewState();
}

class _LoginScreenViewState extends State<_LoginScreenView> {
  String? _validateCredentials({
    required String userName,
    required String password,
  }) {
    if (userName.isEmpty) return "Enter username";
    if (password.isEmpty) return "Enter password";
    bool isValidPassword =
    LoginValueValidator.isValidPassword(password: password);
    bool isValidUsername =
    LoginValueValidator.isValidUsername(username: userName);

    if (!isValidUsername) {
      return "Invalid username should contain 6 characters without space ";
    } else if (!isValidPassword) {
      return "Invalid password should contain 6 characters without space ";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;

    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is UserLoginState) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen(),));
        }
        if (state is LoginValidationFailState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message ?? "Validation Error")),
          );
        }

        if (state is LoginViewStateChangeState) {
          if (state.viewState == ViewState.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Successful")),
            );
            // Navigator.pushReplacement(...);
          } else if (state.viewState == ViewState.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Login Failed")),
            );
          }
        }
      },
      builder: (context, state) {
        final isLoading = state is LoginViewStateChangeState &&
            state.viewState == ViewState.loading;
        return Scaffold(
          backgroundColor: AppPalette.appPrimaryColor,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: size.height * 0.4),
                Container(
                  height: size.height * 0.6,
                  width: size.width,
                  decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: AppPalette.offWhiteColor,
                        blurRadius: 1,
                        spreadRadius: 8,
                        offset: Offset(0, -8),
                      )
                    ],
                    color: AppPalette.whiteColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CustomTextField(
                          isPassword: false,
                          height: size.height * 0.1,
                          width: size.width * 0.9,
                          controller: userNameController,
                          labelText: "Username",
                          maxLength: 6,
                        ),
                        CustomTextField(
                          isPassword: true,
                          height: size.height * 0.1,
                          width: size.width * 0.9,
                          controller: passwordController,
                          labelText: "Password",
                          maxLength: 6,
                        ),
                        (!isLoading)
                            ? CustomButton(
                          height: size.height * 0.08,
                          width: size.width * 0.9,
                          buttonText: "Login",
                          onTap: () {
                            String? validationMessage =
                            _validateCredentials(
                              userName: userNameController.text.trim(),
                              password: passwordController.text.trim(),
                            );
                            if (validationMessage == null) {
                              context
                                  .read<LoginBloc>()
                                  .add(UserLoginEvent(
                                userName: userNameController.text,
                                password: passwordController.text,
                              ));
                            } else {
                              context
                                  .read<LoginBloc>()
                                  .add(LoginValidationFailEvent(
                                validationMessage: validationMessage,
                              ));
                            }
                          },
                        )
                            : const Center(
                            child: CircularProgressIndicator(
                              color: AppPalette.appPrimaryColor,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
