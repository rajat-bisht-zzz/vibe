import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.displayName,
    required super.inviteCode,
    required super.createdAt,
    required super.username,
    required super.passwordHash,
  });

  /// Convert JSON → Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    final username = json['username'] ?? json['displayName'] ?? "guest";
    final passwordHash = json['passwordHash'] ?? "";
    return UserModel(
      id: json['id'],
      displayName: json['displayName'] ?? username,
      inviteCode: json['inviteCode'] ?? _generateFallbackCode(),
      createdAt: DateTime.parse(json['createdAt']),
      username: json['username'],
      passwordHash: passwordHash,
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'inviteCode': inviteCode,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert Model → Entity
  User toEntity() {
    return User(
      id: id,
      displayName: displayName,
      inviteCode: inviteCode,
      createdAt: createdAt,
      username: username,
      passwordHash: passwordHash,
    );
  }

  /// Convert Entity → Model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      displayName: user.displayName,
      inviteCode: user.inviteCode,
      createdAt: user.createdAt,
      username: user.username,
      passwordHash: user.passwordHash,
    );
  }

  static String _generateFallbackCode() {
    final millis = DateTime.now().millisecondsSinceEpoch;
    return "VIBE-${millis.toString().substring(7, 13)}";
  }
}
