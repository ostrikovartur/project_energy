import 'package:bloc/bloc.dart';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_energy/authenticationSecond/user/repository/user_repository.dart';

part 'google_auth_event.dart';
part 'google_auth_state.dart';

class GoogleAuthBloc extends Bloc<GoogleAuthEvent, GoogleAuthState> {
  final UserRepository _userRepository;

  GoogleAuthBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(GoogleAuthInitial()) {
    on<GoogleAuthRequested>(_onGoogleAuthRequested);
  }

  Future<void> _onGoogleAuthRequested(
      GoogleAuthRequested event, Emitter<GoogleAuthState> emit) async {
    emit(GoogleAuthLoading());
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final userAccount = await googleSignIn.signIn();

      if (userAccount == null) {
        emit(const GoogleAuthFailure("Google Sign-In was canceled."));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await userAccount.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential =
          await _userRepository.signInWithCredential(credential);

      emit(GoogleAuthSuccess(userCredential.user!));
    } catch (e) {
      log(e.toString());
      emit(GoogleAuthFailure(e.toString()));
    }
  }
}