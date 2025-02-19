import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_energy/authenticationSecond/bloc/authentication_bloc.dart';
import 'package:project_energy/authenticationSecond/signin/bloc/signin_bloc.dart';
import 'package:project_energy/devices.dart';
import 'package:project_energy/home.dart';
import 'package:project_energy/settings/view/settings_screen.dart';
import 'package:project_energy/widgets/footer/bloc/footer_bloc.dart';

class Footer extends StatelessWidget {
  final int currentIndex;

  const Footer({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildFooterButton(
              context,
              iconFilled: Icons.home,
              iconOutlined: Icons.home_outlined,
              label: 'Головна',
              index: 0,
              page: Home(),
            ),
            _buildFooterButton(
              context,
              iconFilled: Icons.lightbulb,
              iconOutlined: Icons.lightbulb_outline,
              label: 'Пристрої',
              index: 1,
              page: Devices(),
            ),
            _buildFooterButton(
              context,
              iconFilled: Icons.account_circle,
              iconOutlined: Icons.account_circle_outlined,
              label: 'Меню',
              index: 2,
              page: SettingsScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooterButton(BuildContext context,
      {required IconData iconFilled,
      required IconData iconOutlined,
      required String label,
      required int index,
      required Widget page}) {
    bool isActive = currentIndex == index;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: Icon(
              isActive ? iconFilled : iconOutlined,
              color: Colors.black,
              size: 30,
            ),
            onPressed: () {
              context.read<FooterBloc>().add(UpdateFooterIndex(index));
              if (index == 2) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return BlocProvider(
                        create: (context) => SignInBloc(
                          userRepository:
                              context.read<AuthenticationBloc>().userRepository,
                        ),
                        child: SettingsScreen(),
                      );
                    },
                  ),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => page),
                );
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Transform.translate(
            offset: const Offset(0, -7),
            child: Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
