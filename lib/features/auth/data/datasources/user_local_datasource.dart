import 'package:sqflite/sqflite.dart';
import 'package:vibe/core/database/database_service.dart';
import 'package:vibe/features/auth/data/models/user_model.dart';
import 'package:vibe/features/auth/domain/entities/user.dart';

class UserLocalDataSource {
  Database get _db => DatabaseService.db;

  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    await _db.insert(
      'users',
      {
        'id': model.id,
        'username': model.username,
        'displayName': model.displayName,
        'passwordHash': model.passwordHash,
        'inviteCode': model.inviteCode,
        'createdAt': model.createdAt.toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByUsername(String username) async {
    final rows = await _db.query(
      'users',
      where: 'LOWER(username) = LOWER(?)',
      whereArgs: [username],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return UserModel.fromJson(rows.first).toEntity();
  }

  Future<List<User>> getAllUsers() async {
    final rows = await _db.query('users');
    return rows.map((row) => UserModel.fromJson(row).toEntity()).toList();
  }
}
