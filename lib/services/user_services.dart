import 'package:appwrite/appwrite.dart';
import 'package:cwi_apps/models/user_model.dart';
import '../services/appwrite_client.dart';

class UserServices {
  final _account = AppwriteService.account;
  final _db = AppwriteService.databases;

  static const String databaseId = '6944300100059c12c035';      // ganti sesuai punyamu
  static const String usersCollection = 'users';     // ganti kalau beda

Future<UserModel> getUserProfile() async {
  try {
    final user = await _account.get();

    final doc = await _db.getDocument(
      databaseId: databaseId,
      collectionId: usersCollection,
      documentId: user.$id,
    );

    return UserModel.fromJson(doc.data);
  } catch (e) {
    print("PROFILE ERROR: $e");
    rethrow;
  }
}
Future<void> updateUserProfile(UserModel user) async {
  await _db.updateDocument(
    databaseId: databaseId,
    collectionId: usersCollection,
    documentId: user.id,
    data: user.toJson(),
  );
}


}
