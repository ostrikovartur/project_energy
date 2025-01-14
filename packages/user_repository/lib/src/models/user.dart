import 'package:equatable/equatable.dart';

class User extends Equatable {
    const User({
    required this.id,
    required this.email,
    required this.password,
  });

  final String id;
  final String email;
  final String password;

  @override
  List<Object> get props => [id, email, password];

  static const empty = User(id: '-', email: '', password: '');

  factory User.fromFirestore(Map<String, dynamic> data, String id) {
    return User(
      id: id,
      email: data['email'] as String,
      password: data['password'] as String,
    );
  }
}