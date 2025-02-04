part of 'google_auth_bloc.dart';

sealed class GoogleAuthState extends Equatable {
  const GoogleAuthState();

  @override
  List<Object> get props => [];
}

class GoogleAuthInitial extends GoogleAuthState {}

class GoogleAuthLoading extends GoogleAuthState {}

class GoogleAuthSuccess extends GoogleAuthState {
  final User user;

  const GoogleAuthSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class GoogleAuthFailure extends GoogleAuthState {
  final String error;

  const GoogleAuthFailure(this.error);

  @override
  List<Object> get props => [error];
}
