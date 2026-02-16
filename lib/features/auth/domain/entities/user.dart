import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String username; // unique login id
  final String displayName; // nickname shown in chats
  final String passwordHash;
  final String inviteCode;
  final DateTime createdAt;

  const User(
      {required this.id,
      required this.username,
      required this.displayName,
      required this.passwordHash,
      required this.inviteCode,
      required this.createdAt});

  @override
  List<Object?> get props =>
      [id, username, displayName, passwordHash, inviteCode, createdAt];
}
