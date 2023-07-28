import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/common/error_page.dart';
import 'package:flutterwrite_chat_jul23/common/loading_page.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/controllers/chats_controller.dart';
import 'package:flutterwrite_chat_jul23/models/conversation_model.dart';

import '../../../constants/appwrite_constants.dart';
import '../../../models/chat_model.dart';
import '../../../models/user_model.dart';
import '../widgets/chat_item.dart';

class ChatsView extends ConsumerStatefulWidget {
  final String identifier;
  final UserModel currentUser;
  final UserModel otherUser;
  const ChatsView({
    super.key,
    required this.identifier,
    required this.currentUser,
    required this.otherUser,
  });

  @override
  ConsumerState<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends ConsumerState<ChatsView> {
  final _chatController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _chatController.dispose();
  }

  void _submitChat(WidgetRef ref) {
    if (_chatController.text.isEmpty) {
      return;
    }
    ConversationModel conversation = ConversationModel(
      identifier: widget.identifier,
      user1Id: widget.currentUser.id,
      user2Id: widget.otherUser.id,
      lastMessage: _chatController.text,
    );
    ref.read(chatsControllerProvider.notifier).sendChat(
          identifier: widget.identifier,
          senderId: widget.currentUser.id,
          message: _chatController.text,
          conversation: conversation,
        );
    _chatController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.otherUser.name),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: NetworkImage(widget.otherUser.imageUrl),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ref.watch(chatsFutureProvider(widget.identifier)).when(
                    data: (data) {
                      ref.watch(getLatestChatProvider).when(
                            data: (realTime) {
                              if (data.contains(
                                  ChatModel.fromMap(realTime.payload))) {
                                return;
                              }
                              if (realTime.events.contains(
                                      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents.*.create') &&
                                  ((realTime.payload['identifier'] ==
                                      widget.identifier))) {
                                data.add(ChatModel.fromMap(realTime.payload));
                              }
                              if (realTime.events.contains(
                                      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents.*.update') &&
                                  ((realTime.payload['identifier'] ==
                                      widget.identifier))) {
                                data
                                    .firstWhere((element) =>
                                        element.id == realTime.payload['\$id'])
                                    .isRead = realTime.payload['isRead'];
                              }
                            },
                            error: (error, stackTrace) =>
                                ErrorText(error: error.toString()),
                            loading: () => const Loader(),
                          );
                      return ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) => ChatItem(
                          chat: data[index],
                          currentUser: widget.currentUser,
                        ),
                      );
                    },
                    error: (error, stackTrace) =>
                        ErrorPage(error: error.toString()),
                    loading: () => const Loader(),
                  ),
            ),
            SizedBox(
              height: 60,
              child: Row(
                children: [
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.file_copy,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: _chatController,
                      onTapOutside: (event) {
                        FocusManager.instance.primaryFocus!.unfocus();
                      },
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    onPressed: () => _submitChat(ref),
                    icon: const RotatedBox(
                      quarterTurns: 3,
                      child: Icon(
                        Icons.send,
                      ),
                    ),
                  ),
                  const SizedBox(width: 15),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
