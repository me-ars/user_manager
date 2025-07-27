import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_manager/ui/screens/home/home_screen.dart';
import '../../state/auth/login/login_bloc.dart';
import '../../state/home/home_bloc.dart';
import '../../ui/screens/auth/login/login_screen.dart';

class UserManager extends StatelessWidget {
  final bool isLggedIn;
  const UserManager({super.key, required this.isLggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (_) => LoginBloc(),
        ),
        BlocProvider<HomeBloc>(
          create: (_) => HomeBloc()..add(FetchAllInitialDataEvent()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );

  }
}
