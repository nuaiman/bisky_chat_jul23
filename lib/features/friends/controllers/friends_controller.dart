import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/apis/user_api.dart';
import 'package:flutterwrite_chat_jul23/models/user_model.dart';

class FriendsController extends StateNotifier<List<UserModel>> {
  final UserApi _userApi;
  FriendsController({required UserApi userApi})
      : _userApi = userApi,
        super([]);

  Future<List<UserModel>> getFriends({required String userId}) async {
    final friends = await _userApi.getAllFriends(userId: userId);
    return friends.fold(
      (l) {
        return [];
      },
      (r) {
        final listOfFriends =
            r.documents.map((e) => UserModel.fromMap(e.data)).toList();
        state = listOfFriends;
        return listOfFriends;
      },
    );
  }

  UserModel getUserModelById(String id) {
    return state.firstWhere((element) => element.id == id);
  }
}
//------------------------------------------------------------------------------

final friendsControllerProvider =
    StateNotifierProvider<FriendsController, List<UserModel>>((ref) {
  final userApi = ref.watch(userApiProvider);
  return FriendsController(userApi: userApi);
});

final friendsListFutureProvider =
    FutureProvider.family((ref, String userId) async {
  final friendsControlleer = ref.watch(friendsControllerProvider.notifier);
  return friendsControlleer.getFriends(userId: userId);
});
