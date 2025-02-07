import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_energy/authenticationSecond/bloc/authentication_bloc.dart';
import 'package:project_energy/authenticationSecond/signin/bloc/signin_bloc.dart';
import 'package:project_energy/authenticationSecond/signin/view/signin.dart';
import 'package:project_energy/authenticationSecond/signup/bloc/signup_bloc.dart';
import 'package:project_energy/authenticationSecond/signup/view/signup.dart';
import 'package:project_energy/widgets/background_widget.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Stack(
        children: [
          // Логотип у верхній частині екрану
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15, // Відступ від верху
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/images/logo2.png',
                height: 200, // Висота логотипа
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height / 1.8,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: TabBar(
                      controller: tabController,
                      unselectedLabelColor:
                          Theme.of(context).colorScheme.onSurfaceVariant,
                      labelColor: Theme.of(context).colorScheme.onSurface,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabController,
                      children: [
                        BlocProvider<SignInBloc>(
                          create: (context) => SignInBloc(
                            userRepository: context
                                .read<AuthenticationBloc>()
                                .userRepository,
                          ),
                          child: const Signin(),
                        ),
                        BlocProvider<SignUpBloc>(
                          create: (context) => SignUpBloc(
                            userRepository: context
                                .read<AuthenticationBloc>()
                                .userRepository,
                          ),
                          child: const SignUp(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
