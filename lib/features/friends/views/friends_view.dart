import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/common/error_page.dart';
import 'package:flutterwrite_chat_jul23/common/loading_page.dart';
import 'package:flutterwrite_chat_jul23/features/chatting/controllers/chats_controller.dart';
import 'package:flutterwrite_chat_jul23/features/friends/controllers/friends_controller.dart';

import '../../auth/controller/auth_controller.dart';

class FriendsView extends ConsumerWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModel = ref.watch(authControllerProvider);
    return ref.watch(friendsListFutureProvider(currentUserModel.id)).when(
          data: (data) {
            return Scaffold(
              appBar: AppBar(
                title: const Text('F R I E N D S'),
              ),
              body: RefreshIndicator(
                onRefresh: () => ref
                    .read(friendsControllerProvider.notifier)
                    .getFriends(userId: currentUserModel.id),
                child: ListView.separated(
                  itemCount: data.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    return ListTile(
                      onTap: () => ref
                          .read(chatsControllerProvider.notifier)
                          .startConversation(
                            context: context,
                            user1: currentUserModel,
                            user2: data[index],
                            lastMessage: '',
                          ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.black,
                        backgroundImage: NetworkImage(data[index].imageUrl),
                      ),
                      title: Text(data[index].name),
                      subtitle: Text(data[index].phone),
                      trailing: Text(data[index].id),
                    );
                  },
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorPage(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
