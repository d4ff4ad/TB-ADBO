import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import '../domain/chat.dart';

part 'chat_remote_source.g.dart';

@riverpod
ChatRemoteSource chatRemoteSource(ChatRemoteSourceRef ref) {
  final host = !kIsWeb && defaultTargetPlatform == TargetPlatform.android
      ? '10.0.2.2'
      : '127.0.0.1';

  return ChatRemoteSource(
    Dio(
      BaseOptions(
        baseUrl: 'http://$host:8000/api',
        headers: {'Accept': 'application/json'},
      ),
    ),
  );
}

class ChatRemoteSource {
  final Dio _dio;

  ChatRemoteSource(this._dio);

  Future<List<Chat>> getChats(String token) async {
    try {
      final response = await _dio.get(
        '/chats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Get Chats Response: ${response.data}');

      if (response.data['data'] == null) return [];

      final List<dynamic> data = response.data['data'];
      return data.map((json) => Chat.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get Chats Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to load chats');
    }
  }

  Future<Chat> createChat(String token) async {
    try {
      final response = await _dio.post(
        '/chats',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Create Chat Response: ${response.data}');

      final data =
          response.data['data'] ??
          response.data; // Handle potential wrapper diffs
      return Chat.fromJson(data);
    } on DioException catch (e) {
      debugPrint('Create Chat Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to start chat');
    }
  }

  Future<List<Message>> getMessages(String token, int chatId) async {
    try {
      final response = await _dio.get(
        '/chats/$chatId/messages',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Get Messages Response: ${response.data}');

      if (response.data['data'] == null) return [];

      final List<dynamic> data = response.data['data'];
      return data.map((json) => Message.fromJson(json)).toList();
    } on DioException catch (e) {
      debugPrint('Get Messages Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to load messages');
    }
  }

  Future<Message> sendMessage(String token, int chatId, String content) async {
    try {
      final response = await _dio.post(
        '/chats/$chatId/messages',
        data: {'content': content},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      debugPrint('Send Message Response: ${response.data}');

      final data = response.data['data'] ?? response.data;
      return Message.fromJson(data);
    } on DioException catch (e) {
      debugPrint('Send Message Error: ${e.response?.data}');
      throw Exception(e.response?.data['message'] ?? 'Failed to send message');
    }
  }

  Future<void> markAsRead(String token, int chatId) async {
    try {
      await _dio.post(
        '/chats/$chatId/read',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } on DioException catch (e) {
      debugPrint('Mark Read Error: ${e.response?.data}');
      // Don't throw, just log. It's a background action.
    }
  }
}
