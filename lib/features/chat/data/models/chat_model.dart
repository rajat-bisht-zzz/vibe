class ChatModel {
  final int? id;
  final String chatId;
  final String userA;
  final String userB;
  final DateTime createdAt;

  ChatModel({
    this.id,
    required this.chatId,
    required this.userA,
    required this.userB,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'chatId': chatId,
      'userA': userA,
      'userB': userB,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return ChatModel(
      id: map['id'] as int?,
      chatId: map['chatId'] as String,
      userA: map['userA'] as String,
      userB: map['userB'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }
}
