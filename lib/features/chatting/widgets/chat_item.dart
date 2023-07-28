import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/controllers/chats_controller.dart';
import 'package:flutterwrite_chat_jul23/models/chat_model.dart';
import 'package:flutterwrite_chat_jul23/models/user_model.dart';

class ChatItem extends ConsumerWidget {
  const ChatItem({
    super.key,
    required this.chat,
    required this.currentUser,
  });

  final ChatModel chat;
  final UserModel currentUser;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myMessage = chat.senderId == currentUser.id;

    if (!myMessage && chat.isRead == false) {
      ref.read(chatsControllerProvider.notifier).updateMessageSeen(chat.id);
    }

    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: myMessage ? MediaQuery.of(context).size.width * 0.3 : 10,
        right: !myMessage ? MediaQuery.of(context).size.width * 0.3 : 10,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: myMessage ? Colors.grey : Colors.green,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(!myMessage ? 0 : 10),
            topRight: Radius.circular(myMessage ? 0 : 10),
            bottomLeft: const Radius.circular(10),
            bottomRight: const Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            right: myMessage ? 5 : 0,
            left: !myMessage ? 5 : 0,
          ),
          child: Column(
            crossAxisAlignment:
                myMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Wrap(
                children: [
                  Text(
                    chat.message,
                    textAlign: myMessage ? TextAlign.right : TextAlign.left,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment:
                    myMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
                children: [
                  Text(
                    chat.date.toString(),
                    textAlign: myMessage ? TextAlign.right : TextAlign.left,
                  ),
                  SizedBox(width: !myMessage ? 0 : 10),
                  Icon(
                    !myMessage
                        ? null
                        : (myMessage && chat.isRead == false)
                            ? Icons.done
                            : Icons.done_all,
                    color: chat.isRead == true ? Colors.indigo : Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
