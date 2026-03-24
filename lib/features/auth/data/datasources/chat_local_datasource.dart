import 'package:sqflite/sqflite.dart';
import 'package:vibe/core/database/isar_service.dart';
import 'package:vibe/features/chat/data/models/chat_model.dart';

import '../../domain/entities/chat.dart';

class ChatLocalDataSource {
  Database get _db => DatabaseService.db;

  Future<void> createChat(Chat chat) async {
    final model = ChatModel(
      chatId: chat.id,
      userA: chat.userA,
      userB: chat.userB,
      createdAt: chat.createdAt,
    );

    await _db.insert(
      'chats',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Chat>> getChats() async {
    final rows = await _db.query('chats');
    return rows
        .map((row) => ChatModel.fromMap(row))
        .map((m) => Chat(
              id: m.chatId,
              userA: m.userA,
              userB: m.userB,
              createdAt: m.createdAt,
            ))
        .toList();
  }

  Future<void> clear() async {
    await _db.delete('chats');
  }
}
