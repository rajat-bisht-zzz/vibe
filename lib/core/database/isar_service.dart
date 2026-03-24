import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static late Database db;

  static Future<void> init() async {
    final dbPath = await getDatabasesPath();

    db = await openDatabase(
      join(dbPath, 'vibe.db'),
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE chats (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            chatId TEXT NOT NULL UNIQUE,
            userA TEXT NOT NULL,
            userB TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');

        await db.execute('''
          CREATE TABLE messages (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            messageId TEXT NOT NULL UNIQUE,
            chatId TEXT NOT NULL,
            senderId TEXT NOT NULL,
            text TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }
}
