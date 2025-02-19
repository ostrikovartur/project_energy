import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_energy/app_view.dart';
import 'package:project_energy/authenticationSecond/bloc/authentication_bloc.dart';
import 'package:project_energy/authenticationSecond/user/repository/user_repository.dart';
import 'package:project_energy/widgets/footer/bloc/footer_bloc.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  const MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Додаємо FooterBloc
        BlocProvider<FooterBloc>(
          create: (context) => FooterBloc(),
        ),
        // вже існуючий Bloc для аутентифікації
        RepositoryProvider<AuthenticationBloc>(
          create: (context) => AuthenticationBloc(
            userRepository: userRepository,
          ),
        ),
      ],
      child: const MyAppView(),
    );
  }
}