import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutterwrite_chat_jul23/core/failure.dart';
import 'package:flutterwrite_chat_jul23/core/type_defs.dart';
import 'package:fpdart/fpdart.dart';
import '../models/conversation_model.dart';

import '../constants/appwrite_constants.dart';
import '../core/providers.dart';
import '../models/chat_model.dart';

abstract class IChatsApi {
  Future<void> startConversation(ConversationModel conversation);

  Future<List<Document>> getAllConversation(int number, String uid);

  FutureEither<void> sendChat({required ChatModel chat});

  Future<List<Document>> getChats({required String identifier});

  Stream<RealtimeMessage> getLatestConversation();
  // Stream<RealtimeMessage> getLatestChat();
  Stream<RealtimeMessage> getLatestChat();

  FutureEither<void> updateMessageSeen(String chatId);
}
// -----------------------------------------------------------------------------

class ChatsApi implements IChatsApi {
  final Databases _databases;
  final Realtime _realtime;
  ChatsApi({required Databases databases, required Realtime realtime})
      : _databases = databases,
        _realtime = realtime;

  @override
  Future<void> startConversation(ConversationModel conversation) async {
    try {
      await _databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.conversationsCollection,
        documentId: conversation.identifier,
        data: {
          'identifier': conversation.identifier,
          'user1Id': conversation.user1Id,
          'user2Id': conversation.user2Id,
          'lastMessage': conversation.lastMessage,
        },
      );
    } on AppwriteException catch (e) {
      if (e.code == 404) {
        await _databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.conversationsCollection,
          documentId: conversation.identifier,
          data: {
            'identifier': conversation.identifier,
            'user1Id': conversation.user1Id,
            'user2Id': conversation.user2Id,
          },
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Document>> getAllConversation(int number, String uid) async {
    DocumentList documents = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.conversationsCollection,
      queries: [
        number == 1 ? Query.equal('user1Id', uid) : Query.equal('user2Id', uid),
      ],
    );
    return documents.documents;
  }

  @override
  FutureEither<void> sendChat({required ChatModel chat}) async {
    try {
      await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.chatsCollection,
        documentId: ID.unique(),
        data: chat.toMap(),
      );
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      return left(Failure(e.message ?? '', stackTrace));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<Document>> getChats({required String identifier}) async {
    final documents = await _databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.chatsCollection,
      queries: [
        Query.equal('identifier', identifier),
      ],
    );
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestConversation() {
    final realtime = _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.conversationsCollection}.documents'
    ]).stream;
    return realtime;
  }

  @override
  Stream<RealtimeMessage> getLatestChat() {
    final realtime = _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.chatsCollection}.documents'
    ]).stream;
    return realtime;
  }

  @override
  FutureEither<void> updateMessageSeen(String chatId) async {
    try {
      await _databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.chatsCollection,
          documentId: chatId,
          data: {
            'isRead': true,
          });
      return right(null);
    } on AppwriteException catch (e, stackTrace) {
      print(e.message);
      return left(Failure(e.message ?? '', stackTrace));
    } catch (e) {
      rethrow;
    }
  }
}
// -----------------------------------------------------------------------------

final chatsApiProvider = Provider((ref) {
  final databases = ref.watch(appwriteDatabaseProvider);
  final realtime = ref.watch(appwriteRealtimeProvider);
  return ChatsApi(databases: databases, realtime: realtime);
});
