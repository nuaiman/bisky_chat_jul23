import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/apis/chats_api.dart';
import 'package:flutterwrite_chat_jul23/features/dashboard/controllers/dashboard_controller.dart';
import 'package:flutterwrite_chat_jul23/models/chat_model.dart';
import 'package:flutterwrite_chat_jul23/models/conversation_model.dart';
import 'package:flutterwrite_chat_jul23/models/user_model.dart';

import '../views/chats_view.dart';

class ChatsController extends StateNotifier<bool> {
  final ChatsApi _chatsApi;
  ChatsController({required ChatsApi chatsApi})
      : _chatsApi = chatsApi,
        super(false);

  void startConversation({
    required BuildContext context,
    required UserModel user1,
    required UserModel user2,
    required String lastMessage,
  }) async {
    List uniqueId = [user1.id, user2.id];
    uniqueId.sort();
    final key = '${uniqueId[0]}_${uniqueId[1]}';
    final conversation = ConversationModel(
      identifier: key,
      user1Id: uniqueId[0],
      user2Id: uniqueId[1],
      lastMessage: lastMessage,
    );
    await _chatsApi.startConversation(conversation);

    if (context.mounted) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ChatsView(
            identifier: key,
            currentUser: user1,
            otherUser: user2,
          ),
        ),
      );
    }
  }

  Future<List<ConversationModel>> getAllConversation(
      {required String userId}) async {
    final listOfConversations1 = await _chatsApi.getAllConversation(1, userId);
    final conversations1 = listOfConversations1
        .map((e) => ConversationModel.fromMap(e.data))
        .toList();
    // ---------------------------
    final listOfConversations2 = await _chatsApi.getAllConversation(2, userId);
    final conversations2 = listOfConversations2
        .map((e) => ConversationModel.fromMap(e.data))
        .toList();
    return conversations1 + conversations2;
  }

  void sendChat({
    required WidgetRef ref,
    required UserModel currentUser,
    required UserModel otherUser,
    required String identifier,
    required String senderId,
    required String message,
    required ConversationModel conversation,
    File? file,
  }) async {
    ChatModel chat = ChatModel(
      id: '',
      identifier: identifier,
      senderId: senderId,
      message: message,
      fileUrl: '',
      isRead: false,
      date: DateTime.now(),
    );
    await _chatsApi.startConversation(conversation);
    await _chatsApi.sendChat(chat: chat);

    await ref.read(dashboardControllerProvider.notifier).sendFcm(
          chat,
          currentUser,
          otherUser,
        );
  }

  Future<List<ChatModel>> getChats({required String identifier}) async {
    final listOfChats = await _chatsApi.getChats(identifier: identifier);
    final chats = listOfChats.map((e) => ChatModel.fromMap(e.data)).toList();
    return chats;
  }

  void updateMessageSeen(String chatId) {
    _chatsApi.updateMessageSeen(chatId);
  }
}
// -----------------------------------------------------------------------------

final chatsControllerProvider =
    StateNotifierProvider<ChatsController, bool>((ref) {
  final chatsApi = ref.watch(chatsApiProvider);
  return ChatsController(chatsApi: chatsApi);
});

final conversationsFutureProvider =
    FutureProvider.family((ref, String userId) async {
  final chatsController = ref.watch(chatsControllerProvider.notifier);
  return chatsController.getAllConversation(userId: userId);
});

final chatsFutureProvider =
    FutureProvider.family((ref, String identifier) async {
  final chatsController = ref.watch(chatsControllerProvider.notifier);
  return chatsController.getChats(identifier: identifier);
});

final getLatestConversationProvider = StreamProvider((ref) {
  final chatApi = ref.watch(chatsApiProvider);
  return chatApi.getLatestConversation();
});

final getLatestChatProvider = StreamProvider((ref) {
  final chatApi = ref.watch(chatsApiProvider);
  return chatApi.getLatestChat();
});
