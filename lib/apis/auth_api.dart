import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fpdart/fpdart.dart';

import '../core/failure.dart';
import '../core/providers.dart';
import '../core/type_defs.dart';

abstract class IAuthApi {
  FutureEither<Token> createSession(
      {required String userId, required String phone});
  FutureEither<Session> verifySession(
      {required String userId, required String secret});
  Future<User?> getCurrentAccount();
  FutureEitherVoid logout();
}
//------------------------------------------------------------------------------

class AuthApi implements IAuthApi {
  final Account _account;
  AuthApi({
    required Account account,
  }) : _account = account;

  @override
  FutureEither<Token> createSession(
      {required String userId, required String phone}) async {
    try {
      Token token =
          await _account.createPhoneSession(userId: userId, phone: phone);
      return right(token);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<Session> verifySession(
      {required String userId, required String secret}) async {
    try {
      Session session =
          await _account.updatePhoneSession(userId: userId, secret: secret);
      return right(session);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<User?> getCurrentAccount() async {
    try {
      return await _account.get();
    } on AppwriteException catch (_) {
      return null;
    } catch (_) {
      return null;
    }
  }

  @override
  FutureEitherVoid logout() async {
    try {
      await _account.deleteSession(sessionId: 'current');
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }
}
//------------------------------------------------------------------------------

final authApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  return AuthApi(
    account: account,
  );
});
