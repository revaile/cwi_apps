import 'package:appwrite/appwrite.dart';
import '../services/appwrite_client.dart';
import '../models/category_model.dart';

class CategoryRepository {
  final _db = AppwriteService.databases;
  final String databaseId = '6944300100059c12c035';
  final String collectionId = 'category';

  Future<List<CategoryModel>> getAllCategories() async {
    final res = await _db.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
    );

    return res.documents.map((doc) {
      final data = doc.data;
      data['\$id'] = doc.$id;
      return CategoryModel.fromAppwrite(data);
    }).toList();
  }

  Future<CategoryModel> getCategory(String id) async {
    final res = await _db.getDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: id,
    );

    final data = res.data;
    data['\$id'] = res.$id;

    return CategoryModel.fromAppwrite(data);
  }
}
