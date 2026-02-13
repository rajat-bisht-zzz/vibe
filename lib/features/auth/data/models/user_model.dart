import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.displayName,
    required super.createdAt,
  });

  /// Convert JSON → Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      displayName: json['displayName'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// Convert Model → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'displayName': displayName,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Convert Model → Entity
  User toEntity() {
    return User(
      id: id,
      displayName: displayName,
      createdAt: createdAt,
    );
  }

  /// Convert Entity → Model
  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      displayName: user.displayName,
      createdAt: user.createdAt,
    );
  }
}
