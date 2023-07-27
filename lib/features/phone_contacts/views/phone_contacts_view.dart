import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/common/error_page.dart';
import 'package:flutterwrite_chat_jul23/common/loading_page.dart';
import 'package:flutterwrite_chat_jul23/features/phone_contacts/controllers/phone_contacts_controller.dart';

import '../../auth/controller/auth_controller.dart';

class PhoneContactsView extends ConsumerWidget {
  const PhoneContactsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModel = ref.watch(authControllerProvider);
    return ref.watch(friendsListFutureProvider(currentUserModel.id)).when(
          data: (data) {
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(data[index].imageUrl),
                  ),
                  title: Text(data[index].name),
                  subtitle: Text(data[index].phone),
                  trailing: Text(data[index].id),
                ),
              ),
            );
          },
          error: (error, stackTrace) => ErrorPage(error: error.toString()),
          loading: () => const Loader(),
        );
  }
}
