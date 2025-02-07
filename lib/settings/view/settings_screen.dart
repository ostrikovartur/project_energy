import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_energy/authenticationSecond/signin/bloc/signin_bloc.dart';
import 'package:project_energy/header.dart';
import 'package:project_energy/widgets/background_widget.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: Header(title: 'Settings'),
      body: Stack(
        children: [
          BackgroundWidget(
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.center,
                  children: [
                    if (user != null) ...[
                      Text(
                        user.email ?? 'No email available',
                        style: GoogleFonts.raleway(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        user.uid,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 30),
                    ],
                    IconButton(
                      onPressed: () async {
                        context.read<SignInBloc>().add(const SignOutRequired());
                      },
                      icon: const Icon(Icons.logout),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
