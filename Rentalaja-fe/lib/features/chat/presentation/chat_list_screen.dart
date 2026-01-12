import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../auth/domain/user.dart';
import '../data/chat_repository.dart';
import '../domain/chat.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;
    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Safety check for token
    if (user.token == null) {
      return const Scaffold(
        body: Center(child: Text('Error: No Authentication Token')),
      );
    }

    final chatsFuture = ref.watch(chatRepositoryProvider).getChats(user.token!);

    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: FutureBuilder<List<Chat>>(
        future: chatsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final chats = snapshot.data ?? [];

          if (chats.isEmpty) {
            if (user.role == UserRole.member) {
              return Center(
                child: ElevatedButton.icon(
                  onPressed: () => _startChat(context, ref, user.token!),
                  icon: const Icon(Icons.chat),
                  label: const Text('Start Chat with Admin'),
                ),
              );
            } else {
              return const Center(child: Text('No active chats'));
            }
          }

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final isMeMember = user.role == UserRole.member;
              // If I am admin, I see the member's name. If I am member, I see 'Admin'
              final displayName = isMeMember ? 'Admin' : chat.user.name;

              return ListTile(
                leading: CircleAvatar(child: Text(displayName[0])),
                title: Text(displayName),
                subtitle: Text(
                  chat.lastMessage?.content ?? 'No messages yet',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (chat.lastMessage != null)
                      Text(
                        DateFormat('HH:mm').format(chat.lastMessage!.createdAt),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    const SizedBox(height: 4),
                    if (chat.unreadCount > 0)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${chat.unreadCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
                onTap: () async {
                  await context.push('/chats/${chat.id}');
                  // Refresh list when coming back from detail to update unread count
                  setState(() {});
                },
              );
            },
          );
        },
      ),
      floatingActionButton: (user.role == UserRole.member)
          ? FloatingActionButton(
              onPressed: () => _startChat(context, ref, user.token!),
              child: const Icon(Icons.message),
            )
          : null,
    );
  }

  Future<void> _startChat(
    BuildContext context,
    WidgetRef ref,
    String token,
  ) async {
    try {
      final chat = await ref.read(chatRepositoryProvider).createChat(token);
      if (context.mounted) {
        context.push('/chats/${chat.id}');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }
}
