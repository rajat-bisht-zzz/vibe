import 'package:sqflite/sqflite.dart';
import 'package:vibe/core/database/isar_service.dart';
import 'package:vibe/features/chat/data/models/message_model.dart';

import '../../domain/entities/message.dart';

class MessageLocalDataSource {
  Database get _db => DatabaseService.db;

  Future<List<Message>> getMessages(String chatId) async {
    final rows = await _db.query(
      'messages',
      where: 'chatId = ?',
      whereArgs: [chatId],
      orderBy: 'createdAt ASC',
    );

    return rows
        .map((row) => MessageModel.fromMap(row))
        .map((m) => Message(
              id: m.messageId,
              chatId: m.chatId,
              senderId: m.senderId,
              text: m.text,
              createdAt: m.createdAt,
            ))
        .toList();
  }

  Future<void> sendMessage(Message message) async {
    final model = MessageModel(
      messageId: message.id,
      chatId: message.chatId,
      senderId: message.senderId,
      text: message.text,
      createdAt: message.createdAt,
    );

    await _db.insert(
      'messages',
      model.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> clear() async {
    await _db.delete('messages');
  }
}
