import 'package:appwrite/appwrite.dart';
import '../services/appwrite_client.dart';
import '../models/product_model.dart';

class ProductRepository {
  final _db = AppwriteService.databases;
  final String databaseId = '6944300100059c12c035';
  final String collectionId = 'Produk';

  // === GET PRODUCT (punya kamu sebelumnya)
  Future<ProductModel> getProduct(String id) async {
    final res = await _db.getDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: id,
    );

    final data = res.data;
    data['\$id'] = res.$id;

    return ProductModel.fromAppwrite(data);
  }

  // === GET ALL (punya kamu sebelumnya)
  Future<List<ProductModel>> getAllProducts() async {
    final res = await _db.listDocuments(
      databaseId: databaseId,
      collectionId: collectionId,
    );

    return res.documents.map((doc) {
      final data = doc.data;
      data['\$id'] = doc.$id;
      return ProductModel.fromAppwrite(data);
    }).toList();
  }

  // ===============================
  // 🚀 CREATE PRODUCT (BARU)
  // ===============================
  Future<void> createProduct(ProductModel product) async {
    await _db.createDocument(
      databaseId: databaseId,
      collectionId: collectionId,
      documentId: ID.unique(),
      data: product.toJson(),
    );
  }

Future<void> updateProduct(ProductModel product) async {
  await _db.updateDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: product.id,
    data: product.toJson(),
  );
}
Future<void> deleteProductWithImage(String id, String? imageId) async {
  await _db.deleteDocument(
    databaseId: databaseId,
    collectionId: collectionId,
    documentId: id,
  );

  if (imageId != null && imageId.isNotEmpty) {
    await AppwriteService.storage.deleteFile(
      bucketId: "6946cc14000feb857399",
      fileId: imageId,
    );
  }
}



}
