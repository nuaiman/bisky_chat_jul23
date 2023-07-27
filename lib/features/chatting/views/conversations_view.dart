import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/controllers/chats_controller.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/views/chats_view.dart';
import 'package:flutterwrite_chat_jul23/features/friends/controllers/friends_controller.dart';

import '../../../common/error_page.dart';
import '../../../common/loading_page.dart';
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
                    // subtitle: Text(conversation.identifier),
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
