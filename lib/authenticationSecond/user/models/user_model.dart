import 'package:equatable/equatable.dart';
import 'package:project_energy/authenticationSecond/user/entities/user_entity.dart';

class UserModel extends Equatable {
  final String userId;
  final String email;

  const UserModel({
    required this.userId,
    required this.email
  });

  static const empty = UserModel(
    userId: '',
    email: ''
  );
  
  UserModel copyWith({
    String? userId,
    String? email
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      email: email ?? this.email
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(
      userId: userId,
      email: email
    );
  }

  static UserModel fromEntity (MyUserEntity entity) {
    return UserModel(
      userId: entity.userId,
      email: entity.email
    );
  }
  
  @override
  List<Object?> get props => [userId, email];
}