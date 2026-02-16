import '../../features/auth/domain/entities/user.dart';

class UserDirectory {
  static final Map<String, User> _usersByInvite = {};
  static final Map<String, User> _usersById = {};

  static void addUser(User user) {
    _usersByInvite[user.inviteCode] = user;
    _usersById[user.id] = user;
  }

  static User? getByInvite(String code) {
    return _usersByInvite[code];
  }

  static User? getById(String id) {
    return _usersById[id];
  }

  static void clear() {
    _usersByInvite.clear();
    _usersById.clear();
  }

  static User? getByUsername(String username) {
    try {
      return _usersById.values.firstWhere(
        (u) => u.username.toLowerCase() == username.toLowerCase(),
      );
    } catch (_) {
      return null;
    }
  }
}
