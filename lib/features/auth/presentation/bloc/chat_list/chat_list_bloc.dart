import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/chat.dart';
import '../../../domain/usecases/get_chats_usecase.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final GetChatsUseCase getChats;

  ChatListBloc(this.getChats) : super(ChatListInitial()) {
    on<LoadChatsEvent>((event, emit) async {
      emit(ChatListLoading());

      final chats = await getChats();

      emit(ChatListLoaded(chats));
    });
  }
}
