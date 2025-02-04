part of 'signup_bloc.dart';

sealed class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpRequired extends SignUpEvent{
	final UserModel user;
	final String password;

	const SignUpRequired(this.user, this.password);
}
