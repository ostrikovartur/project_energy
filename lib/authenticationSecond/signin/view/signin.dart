import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_energy/authenticationSecond/bloc/authentication_bloc.dart';
import 'package:project_energy/authenticationSecond/google_auth/bloc/google_auth_bloc.dart';
import 'package:project_energy/authenticationSecond/signin/bloc/signin_bloc.dart';
import 'package:project_energy/widgets/auth_text_field.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool signInRequired = false;
  IconData iconPassword = CupertinoIcons.eye_fill;
  bool obscurePassword = true;
  String? _errorMsg;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 20),
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: MyTextField(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(CupertinoIcons.mail_solid),
                  errorMsg: _errorMsg,
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please fill in this field';
                    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$')
                        .hasMatch(val)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  })),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: MyTextField(
              controller: passwordController,
              hintText: 'Password',
              obscureText: obscurePassword,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: const Icon(CupertinoIcons.lock_fill),
              errorMsg: _errorMsg,
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Please fill in this field';
                } else if (!RegExp(
                        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
                    //special symbols: (?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])
                    .hasMatch(val)) {
                  return 'Please enter a valid password';
                }
                return null;
              },
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                    if (obscurePassword) {
                      iconPassword = CupertinoIcons.eye_fill;
                    } else {
                      iconPassword = CupertinoIcons.eye_slash_fill;
                    }
                  });
                },
                icon: Icon(iconPassword),
              ),
            ),
          ),
          const SizedBox(height: 20),
          !signInRequired
              ? Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.5,
                      child: TextButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInBloc>().add(SignInRequired(
                                  emailController.text,
                                  passwordController.text));
                            }
                          },
                          style: TextButton.styleFrom(
                              elevation: 3.0,
                              backgroundColor:
                                  Theme.of(context).colorScheme.primary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60))),
                          child: const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                            ),
                          )),
                    ),
                    const SizedBox(height: 10),
                    BlocProvider(
                      create: (context) => GoogleAuthBloc(
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository,
                      ),
                      child: BlocConsumer<GoogleAuthBloc, GoogleAuthState>(
                        listener: (context, state) {
                          if (state is GoogleAuthFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Error: ${state.error}")),
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: TextButton(
                              onPressed: state is GoogleAuthLoading
                                  ? null
                                  : () {
                                      context
                                          .read<GoogleAuthBloc>()
                                          .add(GoogleAuthRequested());
                                    },
                              style: TextButton.styleFrom(
                                elevation: 3.0,
                                backgroundColor:
                                    Theme.of(context).colorScheme.secondary,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: state is GoogleAuthLoading
                                    ? const CircularProgressIndicator(
                                        color: Colors.white)
                                    : const Text(
                                        "Sign in with Google",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  ],
                )
              : const CircularProgressIndicator(),
        ],
      ),
    );
  }
}
