import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:user_repository/user_repository.dart';

class AuthenticationController {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final UserRepository _userRepository;

  AuthenticationController({
    firebase_auth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    UserRepository? userRepository,
  })  : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _userRepository = userRepository ?? UserRepository();

  Future<void> signIn(User user) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: user.email,
        password: user.password,
      );

      final userDoc = await _firestore
          .collection('users')
          .doc(userCredential.user?.uid)
          .get();

      if (!userDoc.exists) {
        throw LogInWithEmailAndPasswordFailure('User does not exist.');
      }

      final authenticatedUser = User.fromFirestore(userDoc.data()!, userCredential.user!.uid);
      _userRepository.setUser(authenticatedUser);
    } on firebase_auth.FirebaseAuthException catch (e) {
      throw LogInWithEmailAndPasswordFailure.fromCode(e.code);
    } catch (e) {
      throw LogInWithEmailAndPasswordFailure(e.toString());
    }
  }
}