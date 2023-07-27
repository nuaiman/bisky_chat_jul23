import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/features/auth/view/update_user_profile_view.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/view/auth_phone_view.dart';
import 'features/dashboard/views/dashboard_view.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bisky Chat',
      theme: ThemeData(useMaterial3: true),
      home: ref.watch(getCurrentAccountProvider).when(
            data: (data) {
              if (data == null) {
                return const AuthPhoneView();
              } else if (data.name.isEmpty) {
                return UpdateUserProfileView(userId: data.$id);
              } else {
                return const DashboardView();
              }
            },
            error: (error, stackTrace) => ErrorPage(error: error.toString()),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
