import 'project_id_secret_pass.dart';

class AppwriteConstants {
  static const String projectId = projectIdSecretPass;
  static const String databaseId = '6497a40499b498ec312f';
  static const String endPoint = 'https://cloud.appwrite.io/v1';

  static const String serverKey = projectFirebaseFCMServerKey;

  static const String usersCollection = '6497a42638f9887ee6ee';
  static const String conversationsCollection = '64c2b57f0fc08da3577e';
  static const String chatsCollection = '6497f0108d905822de39';

  static const String imagesBucket = '6497a41867fab4877915';

  static String imageUrl(String imageId) =>
      '$endPoint/storage/buckets/$imagesBucket/files/$imageId/view?project=$projectId&mode=admin';
}
