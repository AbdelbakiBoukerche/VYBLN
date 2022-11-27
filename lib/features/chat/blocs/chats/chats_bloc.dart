import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/injection_container.dart';
import '../../../auth/blocs/auth/auth_bloc.dart';
import '../../models/chat.dart';
import '../../repositories/chat_repository.dart';

part 'chats_event.dart';
part 'chats_state.dart';

class ChatsBloc extends Bloc<ChatsEvent, ChatsState> {
  ChatsBloc({required ChatRepository chatRepository})
      : _chatRepository = chatRepository,
        super(const ChatsState()) {
    on<ChatsFetchChats>(_onFetchChats);
  }

  final ChatRepository _chatRepository;

  final _user = (sl<AuthBloc>().state as AuthUserAuthenticated).mUser;

  void _onFetchChats(
    ChatsFetchChats event,
    Emitter<ChatsState> emit,
  ) async {
    final result = await _chatRepository.getChats(_user);
    emit(state.copyWith(chats: result));
  }
}
