import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/register_page.dart';
import '../../features/auth/presentation/splash_page.dart';
import '../../features/catalogue/presentation/catalogue_page.dart';
import '../../features/catalogue/presentation/detail_page.dart';
import '../../features/catalogue/presentation/add_item_page.dart';
import '../../features/catalogue/presentation/edit_item_page.dart';
import '../../features/catalogue/presentation/admin_transaction_page.dart';
import '../../features/chat/presentation/chat_list_screen.dart';
import '../../features/chat/presentation/chat_detail_screen.dart';
import '../presentation/main_wrapper.dart';
import '../../features/catalogue/presentation/history_page.dart';
import '../../features/auth/presentation/profile_page.dart';

part 'app_router.g.dart';

@riverpod
GoRouter router(RouterRef ref) {
  final rootNavigatorKey = GlobalKey<NavigatorState>();

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/home',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Stateful Nested Navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapper(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home (Catalogue)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const CataloguePage(),
              ),
            ],
          ),

          // Branch 1: History
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/history',
                builder: (context, state) => const HistoryPage(),
              ),
            ],
          ),

          // Branch 2: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // Standalone Routes (accessible from anywhere)
      GoRoute(
        parentNavigatorKey: rootNavigatorKey, // Hide BottomBar
        path: '/detail/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DetailPage(id: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/add-item',
        builder: (context, state) => const AddItemPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/edit-item/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return EditItemPage(itemId: id);
        },
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/admin/orders',
        builder: (context, state) => const AdminTransactionPage(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/chats',
        builder: (context, state) => const ChatListScreen(),
      ),
      GoRoute(
        parentNavigatorKey: rootNavigatorKey,
        path: '/chats/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return ChatDetailScreen(chatId: id);
        },
      ),
    ],
  );
}
