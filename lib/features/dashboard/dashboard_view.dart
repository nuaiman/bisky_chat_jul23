import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/features/auth/controller/auth_controller.dart';
import 'package:flutterwrite_chat_jul23/features/auth/view/update_user_profile_view.dart';

class DashboardView extends ConsumerWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUserModel = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    UpdateUserProfileView(userId: currentUserModel.id),
              ),
            );
          },
          icon: const Icon(
            Icons.person,
          ),
        ),
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            onPressed: () {
              ref.read(authControllerProvider.notifier).logout(context);
            },
            icon: const Icon(
              Icons.power_settings_new,
            ),
          ),
        ],
      ),
    );
  }
}
