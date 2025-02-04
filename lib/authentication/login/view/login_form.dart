import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:project_energy/authentication/controller/authentication_controller.dart';
import 'package:project_energy/authentication/login/login.dart';
import 'package:project_energy/authentication/login/bloc/login_bloc.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  late final AuthenticationController _authenticationController;
  final TextEditingController _usernameController = TextEditingController(text: 'test@gmail.com');
  final TextEditingController _passwordController = TextEditingController();
  String? _usernameError, _passwordError;

  @override
  void initState() {
    super.initState();
    _authenticationController = AuthenticationController();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status == FormzSubmissionStatus.failure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              const SnackBar(content: Text('Authentication Failure')),
            );
        }
      },
      child: Column(
        children: [
          _EmailInput(controller: _usernameController),
          const SizedBox(height: 8),
          _PasswordInput(controller: _passwordController),
          const SizedBox(height: 8),
          _LoginButton(),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_emailInput_textField'),
          controller: controller,
          onChanged: (email) => context.read<LoginBloc>().add(LoginEmailChanged(email)),
          decoration: InputDecoration(
            labelText: 'Email',
            errorText: state.email.isNotValid ? 'Invalid email' : null,
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextField(
          key: const Key('loginForm_passwordInput_textField'),
          controller: controller,
          onChanged: (password) => context.read<LoginBloc>().add(LoginPasswordChanged(password)),
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Password',
            errorText: state.password.isNotValid ? 'Invalid password' : null,
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status || previous.isValid != current.isValid,
      builder: (context, state) {
        return state.status == FormzSubmissionStatus.inProgress
            ? const CircularProgressIndicator()
            : ElevatedButton(
                key: const Key('loginForm_continue_raisedButton'),
                onPressed: state.isValid
                    ? () => context.read<LoginBloc>().add(const LoginSubmitted())
                    : null,
                child: const Text('Login'),
              );
      },
    );
  }
}