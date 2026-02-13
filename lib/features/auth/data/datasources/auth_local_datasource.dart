import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vibe/features/auth/domain/entities/user.dart';

import '../models/user_model.dart';

class AuthLocalDataSource {
  final FlutterSecureStorage secureStorage;
  static const String userKey = 'CURRENT_USER';

  AuthLocalDataSource(this.secureStorage);

  Future<void> saveUser(User user) async {
    final model = UserModel.fromEntity(user);
    await secureStorage.write(
      key: userKey,
      value: jsonEncode(model.toJson()),
    );
  }

  Future<User?> getUser() async {
    final jsonString = await secureStorage.read(key: userKey);

    if (jsonString == null) return null;

    final map = jsonDecode(jsonString);
    final model = UserModel.fromJson(map);
    return model.toEntity();
  }

  Future<void> clearUser() async {
    await secureStorage.delete(key: userKey);
  }
}
