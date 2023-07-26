import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../constants/appwrite_constants.dart';
import '../core/providers.dart';

abstract class IStorageApi {
  Future<String> uploadImage(String filePath, String userId);
  Future<List<String>> uploadImages(List<File> files);
}

// -----------------------------------------------------------------------------

class StorageApi implements IStorageApi {
  final Storage _storage;
  StorageApi({required Storage storage}) : _storage = storage;

  @override
  Future<String> uploadImage(String filePath, String userId) async {
    try {
      await _storage.deleteFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: userId,
      );

      final uploadedImageLink = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: userId,
        // file: InputFile(path: file.path),
        file: InputFile.fromPath(path: File(filePath).path),
      );
      return AppwriteConstants.imageUrl(uploadedImageLink.$id);
    } on AppwriteException catch (_) {
      final uploadedImageLink = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: userId,
        // file: InputFile(path: file.path),
        file: InputFile.fromPath(path: File(filePath).path),
      );
      return AppwriteConstants.imageUrl(uploadedImageLink.$id);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> uploadImages(List<File> files) async {
    List<String> imageLinks = [];
    for (final file in files) {
      final uploadedImageLink = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucket,
        fileId: ID.unique(),
        // file: InputFile(path: file.path),
        file: InputFile.fromPath(path: file.path),
      );
      imageLinks.add(AppwriteConstants.imageUrl(uploadedImageLink.$id));
    }
    return imageLinks;
  }
}

// -----------------------------------------------------------------------------

final storageApiProvider = Provider((ref) {
  final storage = ref.watch(appwriteStorageProvider);
  return StorageApi(storage: storage);
});
