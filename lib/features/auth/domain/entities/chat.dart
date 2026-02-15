import 'package:equatable/equatable.dart';

class Chat extends Equatable {
  final String id;
  final String userA;
  final String userB;
  final DateTime createdAt;

  const Chat(
      {required this.id,
      required this.userA,
      required this.userB,
      required this.createdAt});

  @override
  List<Object?> get props => [id, userA, userB, createdAt];
}
