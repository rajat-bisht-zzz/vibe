import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';

import '../../../../../core/services/service_locator.dart';
import '../../../../../core/storage/storage_manager.dart';
import '../../../domain/entities/message.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import '../../../domain/usecases/watch_messages_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final SendMessageUseCase sendMessage;
  final GetMessagesUseCase getMessages;
  final WatchMessagesUseCase watchMessages;
  StreamSubscription<List<Message>>? _messagesSub;

  ChatBloc(this.sendMessage, this.getMessages, this.watchMessages)
      : super(ChatInitial()) {
    on<LoadMessagesEvent>((event, emit) async {
      final msgs = await getMessages(event.chatId);
      emit(ChatLoaded(msgs));

      await _messagesSub?.cancel();
      _messagesSub = watchMessages(event.chatId).listen(
        (messages) => add(MessagesUpdatedEvent(messages)),
      );
    });

    on<MessagesUpdatedEvent>((event, emit) {
      emit(ChatLoaded(List.from(event.messages)));
    });

    on<SendMessageEvent>((event, emit) async {
      final userId = getIt<SessionManager>().currentUser!.id;

      final myMessage = Message(
        id: const Uuid().v4(),
        chatId: event.chatId,
        senderId: userId,
        text: event.text,
        createdAt: DateTime.now(),
      );

      await sendMessage(myMessage);
    });
  }

  @override
  Future<void> close() async {
    await _messagesSub?.cancel();
    return super.close();
  }
}
