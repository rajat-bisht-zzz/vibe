part of 'auth_bloc.dart';

abstract class AuthEvent {}

class CheckAuthEvent extends AuthEvent {}

class RegisterEvent extends AuthEvent {
  final String username;
  final String password;
  final String displayName;

  RegisterEvent(this.username, this.password, this.displayName);
}

class LoginEvent extends AuthEvent {
  final String username;
  final String password;

  LoginEvent(this.username, this.password);
}

class LogoutEvent extends AuthEvent {}
