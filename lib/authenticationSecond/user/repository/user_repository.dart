import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_energy/authenticationSecond/user/models/user_model.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<UserModel> signUp(UserModel userModel, String password);

  Future<void> setUserData(UserModel userModel);

  Future<void> signIn(String email, String password);

  Future<UserCredential> signInWithCredential(AuthCredential credential);

  Future<void> logOut();
}