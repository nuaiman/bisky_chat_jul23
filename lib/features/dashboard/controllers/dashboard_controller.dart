import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/apis/user_api.dart';
import 'package:flutterwrite_chat_jul23/constants/appwrite_constants.dart';
import 'package:flutterwrite_chat_jul23/models/chat_model.dart';
import 'package:flutterwrite_chat_jul23/models/user_model.dart';

import 'package:http/http.dart' as http;

class DashboardController extends StateNotifier<bool> {
  final UserApi _userApi;
  DashboardController({required UserApi userApi})
      : _userApi = userApi,
        super(false);

  // --- FCM ---
  void createFcmToken(String userId) {
    FirebaseMessaging.instance.getToken().then((value) {
      print('Token ==> $value');
      _userApi.updateUserFcmToken(userId, value!);
    });
  }

  sendPayload(String reciverToken, Map<String, dynamic> data) async {
    http.Response response = await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=${AppwriteConstants.serverKey}',
      },
      body: jsonEncode({'data': data, 'to': reciverToken}),
    );

    print('Response Code ===> ${response.statusCode}');
    print('Response Code ===> ${response.body}');
  }

  sendFcm(ChatModel chat, UserModel currentUser, UserModel otherUser) async {
    final body = {
      'fromId': currentUser.id,
      'fromName': currentUser.name,
      'message': chat.message,
    };

    sendPayload(otherUser.fcmToken!, body);
  }
  // --- FCM ---
}
// -----------------------------------------------------------------------------

final dashboardControllerProvider =
    StateNotifierProvider<DashboardController, bool>((ref) {
  final userApi = ref.watch(userApiProvider);
  return DashboardController(userApi: userApi);
});
