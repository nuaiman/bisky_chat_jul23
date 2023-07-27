import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/controllers/chats_controller.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/views/chats_view.dart';
import 'package:flutterwrite_chat_jul23/features/friends/controllers/friends_controller.dart';
import 'package:flutterwrite_chat_jul23/models/conversation_model.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
import '../../../constants/appwrite_constants.dart';
import '../../auth/controller/auth_controller.dart';

class ConversationsView extends ConsumerWidget {
  const ConversationsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModel = ref.watch(authControllerProvider);
    return ref.watch(conversationsFutureProvider(currentUserModel.id)).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('C O N V E S A T I O N S'),
              ),
              body: ListView.separated(
                itemCount: data.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  // -------------------
                  final conversation = data[index];
                  final otherUserId =
                      conversation.user1Id == currentUserModel.id
                          ? conversation.user2Id
                          : conversation.user1Id;
                  final otherUser = ref
                      .read(friendsControllerProvider.notifier)
                      .getUserModelById(otherUserId);
                  // -------------------
                  String lastMessage = conversation.lastMessage;
                  // ------------------- Realtime for getting latest Conversation for header -----
                  ref.watch(getLatestConversationProvider).when(
                        data: (realTime) {
                          if (data.contains(
                              ConversationModel.fromMap(realTime.payload))) {
                            return;
                          }
                          if (realTime.events.contains(
                              'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.conversationsCollection}.documents.*.create')) {
                            lastMessage = realTime.payload['message'];
                            data.add(
                                ConversationModel.fromMap(realTime.payload));
                          }
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                  // ------------------- Realtime for getting latest Chat for header -----
                  ref.watch(getLatestChatProvider).when(
                        data: (realTime) {
                          if (realTime.events.contains(
                                  'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents.*.create') &&
                              ((realTime.payload['identifier'] ==
                                  conversation.identifier))) {
                            lastMessage = realTime.payload['message'];
                          }
                        },
                        error: (error, stackTrace) =>
                            ErrorText(error: error.toString()),
                        loading: () => const Loader(),
                      );
                  // -------------------
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ChatsView(
                            identifier: conversation.identifier,
                            currentUser: currentUserModel,
                            otherUser: otherUser,
                          ),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.black,
                      backgroundImage: NetworkImage(otherUser.imageUrl),
                    ),
                    title: Text(otherUser.name),
                    subtitle: Text(lastMessage),
                    trailing: Text(otherUser.id),
                  );
                },
              ),
            );
          },
          error: (error, stackTrace) => ErrorPage(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
