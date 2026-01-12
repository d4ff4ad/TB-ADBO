import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/chat.dart';
import 'chat_remote_source.dart';

part 'chat_repository.g.dart';

@riverpod
ChatRepository chatRepository(ChatRepositoryRef ref) {
  final remoteSource = ref.watch(chatRemoteSourceProvider);
  return ChatRepository(remoteSource);
}

class ChatRepository {
  final ChatRemoteSource _remoteSource;

  ChatRepository(this._remoteSource);

  Future<List<Chat>> getChats(String token) {
    return _remoteSource.getChats(token);
  }

  Future<Chat> createChat(String token) {
    return _remoteSource.createChat(token);
  }

  Future<List<Message>> getMessages(String token, int chatId) {
    return _remoteSource.getMessages(token, chatId);
  }

  Future<Message> sendMessage(String token, int chatId, String content) {
    return _remoteSource.sendMessage(token, chatId, content);
  }

  Future<void> markAsRead(String token, int chatId) {
    return _remoteSource.markAsRead(token, chatId);
  }
}
