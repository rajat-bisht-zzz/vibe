import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String displayName;
  final String inviteCode;
  final DateTime createdAt;

  const User(
      {required this.id,
      required this.displayName,
      required this.inviteCode,
      required this.createdAt});

  @override
  List<Object?> get props => [id, displayName, inviteCode, createdAt];
}
