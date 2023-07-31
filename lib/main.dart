import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/features/auth/view/update_user_profile_view.dart';

import 'common/error_page.dart';
import 'common/loading_page.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/auth/view/auth_phone_view.dart';
import 'features/dashboard/views/dashboard_view.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await AwesomeNotifications().initialize(
    null, //'resource://drawable/res_app_icon',//
    [
      NotificationChannel(
          channelKey: 'alerts',
          channelName: 'Alerts',
          channelDescription: 'Notification tests as alerts',
          playSound: true,
          onlyAlertOnce: true,
          groupAlertBehavior: GroupAlertBehavior.Children,
          importance: NotificationImportance.High,
          defaultPrivacy: NotificationPrivacy.Private,
          defaultColor: Colors.deepPurple,
          ledColor: Colors.deepPurple)
    ],
    debug: false,
  );

  FirebaseMessaging.onBackgroundMessage(myBgMsgHandler);
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

Future<void> myBgMsgHandler(RemoteMessage message) async {
  final messageMap = message.data;

  bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
  // if (!isAllowed) isAllowed = await displayNotificationRationale();
  if (!isAllowed) return;

  await AwesomeNotifications().createNotification(
    content: NotificationContent(
      id: 999, // -1 is replaced by a random number
      channelKey: 'alerts',
      title: '${messageMap['fromName']} sent a message',
      body: '${messageMap['message']}',
    ),
  );
}
