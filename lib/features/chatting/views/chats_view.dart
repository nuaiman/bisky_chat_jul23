import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/user_model.dart';

class ChatsView extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(otherUser.name),
        actions: [
          CircleAvatar(
            backgroundColor: Colors.black,
            backgroundImage: NetworkImage(otherUser.imageUrl),
          ),
          const SizedBox(width: 10),
        ],
      ),
    );
  }
}
