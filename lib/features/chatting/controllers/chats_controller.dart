import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/apis/chats_api.dart';
import 'package:flutterwrite_chat_jul23/models/conversation_model.dart';
import 'package:flutterwrite_chat_jul23/models/user_model.dart';

import '../views/chats_view.dart';

class ChatsController extends StateNotifier<bool> {
  final ChatsApi _chatsApi;
  ChatsController({required ChatsApi chatsApi})
      : _chatsApi = chatsApi,
        super(false);

  void startConversation(
      {required BuildContext context,
      required UserModel user1,
      required UserModel user2}) async {
    List uniqueId = [user1.id, user2.id];
    uniqueId.sort();
    final key = '${uniqueId[0]}_${uniqueId[1]}';
    final conversation = ConversationModel(
      identifier: key,
      user1Id: uniqueId[0],
      user2Id: uniqueId[1],
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
