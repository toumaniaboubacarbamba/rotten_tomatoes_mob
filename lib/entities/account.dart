import 'package:equatable/equatable.dart';

class Account extends Equatable {
  final String id;
  final String email;
  final String name;
  final String token;
  final String? createdAt;

  const Account({
    required this.id,
    required this.email,
    required this.name,
    required this.token,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}