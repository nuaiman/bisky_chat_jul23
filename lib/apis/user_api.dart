import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../constants/appwrite_constants.dart';
import '../core/failure.dart';
import '../models/user_model.dart';
import '../core/providers.dart';
import '../core/type_defs.dart';
import './storage_api.dart';

abstract class IUserApi {
  FutureEither<User> createOrUpdateUser({
    required UserModel userModel,
  });

  FutureEither<DocumentList> getAllFriends({required String userId});

  Future<void> updateUserFcmToken(String userId, String token);
}
// -----------------------------------------------------------------------------

class UserApi implements IUserApi {
  final Account _account;
  final Databases _databases;
  final StorageApi _storageApi;
  UserApi(
      {required Account account,
      required Databases databases,
      required StorageApi storage})
      : _account = account,
        _databases = databases,
        _storageApi = storage;

  @override
  FutureEither<User> createOrUpdateUser({
    required UserModel userModel,
  }) async {
    try {
      await _account.updateName(name: userModel.name);
      //---------
      final imageUrl =
          await _storageApi.uploadImage(userModel.imageUrl, userModel.id);
      // ---------
      User user = await _account.updatePrefs(
        prefs: {
          'userId': userModel.id,
          'name': userModel.name,
          'phone': userModel.phone,
          'imageUrl': imageUrl,
        },
      );
      //++++++++++++++++++++ Update/ Create User in database +++++++++++++++++++
      try {
        await _databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userModel.id,
          data: {
            'userId': userModel.id,
            'name': userModel.name,
            'phone': userModel.phone,
            'imageUrl': imageUrl,
          },
        );
      } on AppwriteException catch (e) {
        if (e.code == 404) {
          await _databases.createDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.usersCollection,
            documentId: userModel.id,
            data: {
              'userId': userModel.id,
              'name': userModel.name,
              'phone': userModel.phone,
              'imageUrl': imageUrl,
            },
          );
        }
      } catch (e) {
        rethrow;
      }
      //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

      return right(user);
    } on AppwriteException catch (e, stackTrace) {
      return left(
          Failure(e.message ?? 'Some unexpected error occured!', stackTrace));
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  FutureEither<DocumentList> getAllFriends({required String userId}) async {
    try {
      final friends = await _databases.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          queries: [
            Query.notEqual('userId', userId),
          ]);
      return right(friends);
    } catch (e, stackTrace) {
      return left(Failure(e.toString(), stackTrace));
    }
  }

  @override
  Future<void> updateUserFcmToken(String userId, String token) async {
    try {
      await _databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: userId,
          data: {
            'fcmToken': token,
          });
    } catch (e) {
      rethrow;
    }
  }
}
// -----------------------------------------------------------------------------

final userApiProvider = Provider((ref) {
  final account = ref.watch(appwriteAccountProvider);
  final databases = ref.watch(appwriteDatabaseProvider);
  final storage = ref.watch(storageApiProvider);
  return UserApi(account: account, databases: databases, storage: storage);
});
