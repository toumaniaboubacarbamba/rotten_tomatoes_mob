//Les objets qui savent lire/écrire le JSON. Ils étendent les entities.
import 'package:rotten_tomatoes/entities/account.dart';

class UserModel extends Account {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.token,
    super.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    id: json['id'] as String,
    email: json['email'] as String,
    name: json['name'] as String,
    token: json['token'] as String,
    createdAt: json['created_at'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'name': name,
    'token': token,
    'created_at': createdAt,
  };
}
