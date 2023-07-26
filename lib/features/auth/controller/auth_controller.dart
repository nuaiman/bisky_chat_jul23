import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/apis/user_api.dart';
import '../view/update_user_profile_view.dart';
import '../../dashboard/dashboard_view.dart';
import '../../loading/loading_controller.dart';
import '../../../models/user_model.dart';

import '../../../apis/auth_api.dart';
import '../../../core/utils.dart';
import '../view/auth_otp_view.dart';
import '../view/auth_phone_view.dart';

class AuthControllerNotifier extends StateNotifier<UserModel> {
  final AuthApi _authApi;
  final UserApi _userApi;
  final LoadingNotifier _loader;
  AuthControllerNotifier({
    required AuthApi authApi,
    required UserApi userApi,
    required LoadingNotifier loader,
  })  : _authApi = authApi,
        _userApi = userApi,
        _loader = loader,
        super(
          UserModel(
            id: '',
            name: '',
            phone: '',
            imageUrl: '',
          ),
        );

  User? _currentAppwriteUser;
  User get currentAppwriteUser => _currentAppwriteUser!;

  void createSession({
    required BuildContext context,
    required String phone,
  }) async {
    _loader.changeLoadingStatus(true);
    final result = await _authApi.createSession(
        userId: phone.split('+').last, phone: phone);

    result.fold(
      (l) {
        _loader.changeLoadingStatus(false);
        showSnackbar(context, l.message);
      },
      (r) {
        _loader.changeLoadingStatus(false);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => AuthOtpView(
            userId: r.userId,
          ),
        ));
      },
    );
  }

  void verifySession({
    required BuildContext context,
    required String userId,
    required String secret,
  }) async {
    _loader.changeLoadingStatus(true);
    final result = await _authApi.verifySession(userId: userId, secret: secret);

    result.fold(
      (l) {
        _loader.changeLoadingStatus(false);
        showSnackbar(context, l.message);
      },
      (r) {
        _loader.changeLoadingStatus(false);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => UpdateUserProfileView(userId: userId),
          ),
          (route) => false,
        );
      },
    );
  }

  Future<void> createOrUpdateUser(
    WidgetRef ref,
    BuildContext context,
    String userId,
    String name,
    String phone,
    String imagePath,
  ) async {
    _loader.changeLoadingStatus(true);
    final result = await _userApi.createOrUpdateUser(
      userModel: UserModel(
        id: userId,
        name: name,
        phone: phone,
        imageUrl: imagePath,
      ),
    );

    result.fold(
      (l) {
        _loader.changeLoadingStatus(false);
        showSnackbar(context, l.message);
      },
      (r) {
        _currentAppwriteUser = r;
        state = UserModel(
          id: r.$id,
          name: r.name,
          phone: r.phone,
          imageUrl: r.prefs.data['imageUrl'],
        );

        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const DashboardView(),
          ),
          (route) => false,
        );

        _loader.changeLoadingStatus(false);
      },
    );
  }

  Future<User?> getCurrentAccount() async {
    User? user = await _authApi.getCurrentAccount();

    if (user != null) {
      _currentAppwriteUser = user;
      state = UserModel(
        id: user.$id,
        name: user.name,
        phone: user.phone,
        imageUrl: user.prefs.data['imageUrl'],
      );
    }
    return user;
  }

  void logout(BuildContext context) async {
    final result = await _authApi.logout();
    result.fold(
      (l) => null,
      (r) => Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPhoneView(),
          ),
          (route) => false),
    );
  }
}
// -----------------------------------------------------------------------------

final authControllerProvider =
    StateNotifierProvider<AuthControllerNotifier, UserModel>((ref) {
  final authApi = ref.watch(authApiProvider);
  final userApi = ref.watch(userApiProvider);
  final loader = ref.watch(loadingProvider.notifier);
  return AuthControllerNotifier(
      authApi: authApi, userApi: userApi, loader: loader);
});

final getCurrentAccountProvider = FutureProvider((ref) async {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getCurrentAccount();
});
