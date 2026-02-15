import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../../core/services/service_locator.dart';
import '../../../../../core/storage/storage_manager.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessage;
  final GetMessagesUseCase getMessages;

  ChatBloc(this.sendMessage, this.getMessages) : super(ChatInitial()) {
    on<LoadMessagesEvent>((event, emit) async {
      final msgs = await getMessages(event.chatId);
      emit(ChatLoaded(msgs));
    });

    on<SendMessageEvent>((event, emit) async {
      final userId = getIt<SessionManager>().currentUser!.id;

      /// YOUR MESSAGE
      final myMessage = Message(
        id: const Uuid().v4(),
        chatId: event.chatId,
        senderId: userId,
        text: event.text,
        createdAt: DateTime.now(),
      );

      await sendMessage(myMessage);

      var msgs = await getMessages(event.chatId);
      emit(ChatLoaded(msgs));

      /// SIMULATED FRIEND REPLY
      await Future.delayed(const Duration(seconds: 1));

      final botReply = Message(
        id: const Uuid().v4(),
        chatId: event.chatId,
        senderId: "friend", // different sender
        text: _generateReply(event.text),
        createdAt: DateTime.now(),
      );

      await sendMessage(botReply);

      msgs = await getMessages(event.chatId);
      emit(ChatLoaded(msgs));
    });
  }
  String _generateReply(String text) {
    text = text.toLowerCase();

    if (text.contains("hi") || text.contains("hello")) {
      return "Hey 👋";
    }

    if (text.contains("how are")) {
      return "I'm good! What about you?";
    }

    if (text.contains("name")) {
      return "I’m your Vibe test friend 😄";
    }

    return "Nice!";
  }
}
