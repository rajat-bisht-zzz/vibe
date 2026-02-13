part of 'auth_bloc.dart';

abstract class AuthEvent {}

/// Fired when app launches
class CheckAuthEvent extends AuthEvent {}

/// Fired when user submits name
class RegisterUserEvent extends AuthEvent {
  final String name;

  RegisterUserEvent(this.name);
}
