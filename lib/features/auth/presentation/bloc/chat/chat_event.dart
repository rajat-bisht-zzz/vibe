part of 'chat_bloc.dart';

abstract class ChatEvent {}

class LoadMessagesEvent extends ChatEvent {
  final String chatId;
  LoadMessagesEvent(this.chatId);
}

class SendMessageEvent extends ChatEvent {
  final String chatId;
  final String text;
  SendMessageEvent(this.chatId, this.text);
}
