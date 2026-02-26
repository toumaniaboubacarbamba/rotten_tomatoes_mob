import 'package:rotten_tomatoes/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      token: json['token'],
    );
  }

  // Convertit le UserModel en JSON pour le stockage local
  Map<String, dynamic> toJson() {
    return {'id': id, 'email': email, 'name': name, 'token': token};
  }
}
