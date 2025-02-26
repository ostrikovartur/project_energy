import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:project_energy/authenticationSecond/user/models/user_model.dart';
import 'package:project_energy/authenticationSecond/user/repository/user_repository.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserCredential> signInWithCredential(AuthCredential credential) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user != null) {
        final userDoc = await usersCollection.doc(user.uid).get();
        if (!userDoc.exists) {
          final newUser = UserModel(
            userId: user.uid,
            email: user.email!,
          );
          await setUserData(newUser);
        }
      }
      return userCredential;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp(UserModel userModel, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: userModel.email, password: password);

      userModel = userModel.copyWith(userId: user.user!.uid);
      
      await setUserData(userModel);
      await _createUserDevicesCollection(userModel.userId);
      await _createUserPowerDevicesCollection(userModel.userId);

      return userModel;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  Future<void> _createUserDevicesCollection(String userId) async {
    try {
      await usersCollection.doc(userId).collection('devices');
    } catch (e) {
      log("Error creating devices collection: ${e.toString()}");
      rethrow;
    }
  }

  Future<void> _createUserPowerDevicesCollection(String userId) async { // перевірити чи працюють методи
    try {
      await usersCollection.doc(userId).collection('power_devices');
    } catch (e) {
      log("Error creating power devices collection: ${e.toString()}");
      rethrow;
    }
  }

  @override
  Future<void> setUserData(UserModel userModel) async {
    try {
      await usersCollection
          .doc(userModel.userId)
          .set(userModel.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }
}
