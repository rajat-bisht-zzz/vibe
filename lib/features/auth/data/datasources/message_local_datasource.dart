import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:vibe/core/database/database_service.dart';
import 'package:vibe/features/chat/data/models/message_model.dart';

import '../../domain/entities/message.dart';

class MessageLocalDataSource {
  Database get _db => DatabaseService.db;
  final Map<String, StreamController<List<Message>>> _chatControllers = {};

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

  Stream<List<Message>> watchMessages(String chatId) {
    final controller = _chatControllers.putIfAbsent(
      chatId,
      () => StreamController<List<Message>>.broadcast(),
    );

    Future.microtask(() async {
      final messages = await getMessages(chatId);
      if (!controller.isClosed) {
        controller.add(messages);
      }
    });

    return controller.stream;
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

    await _emitMessages(message.chatId);
  }

  Future<void> clear() async {
    await _db.delete('messages');

    for (final entry in _chatControllers.entries) {
      if (!entry.value.isClosed) {
        entry.value.add(const []);
      }
    }
  }

  Future<void> _emitMessages(String chatId) async {
    final controller = _chatControllers[chatId];
    if (controller == null || controller.isClosed) return;

    final messages = await getMessages(chatId);
    controller.add(messages);
  }
}
