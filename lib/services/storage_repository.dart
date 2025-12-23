import 'package:appwrite/appwrite.dart';
import 'appwrite_client.dart';

class StorageRepository {
  final storage = AppwriteService.storage;
  final String bucketId = "6946cc14000feb857399";

  Future<Map<String, String>> uploadImage(String path) async {
    final result = await storage.createFile(
      bucketId: bucketId,
      fileId: ID.unique(),
      file: InputFile.fromPath(path: path),
    );

    final url =
        "https://sgp.cloud.appwrite.io/v1/storage/buckets/$bucketId/files/${result.$id}/view?project=69441ee9000b1296f6e1";

    return {
      "id": result.$id,
      "url": url,
    };
  }
}
