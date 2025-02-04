import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:project_energy/authenticationSecond/user/models/user_model.dart';
import 'package:project_energy/authenticationSecond/user/repository/user_repository.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
	final UserRepository _userRepository;

  SignUpBloc({
		required UserRepository userRepository
	}) : _userRepository = userRepository,
		super(SignUpInitial()) {
    on<SignUpRequired>((event, emit) async {
			emit(SignUpProcess());
			try {
        UserModel user = await _userRepository.signUp(event.user, event.password);
				await _userRepository.setUserData(user);
				emit(SignUpSuccess());
      } catch (e) {
				emit(SignUpFailure());
      }
    });
  }
}
