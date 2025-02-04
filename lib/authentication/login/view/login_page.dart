import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_energy/authentication/login/login.dart';
import 'package:project_energy/authentication/login/bloc/login_bloc.dart';
import 'package:user_repository/user_repository.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(builder: (_) => const LoginPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: BlocProvider(
          create: (context) => LoginBloc(
            userRepository: context.read<UserRepository>(),
          ),
          child: const LoginForm(),
        ),
      ),
    );
  }
}