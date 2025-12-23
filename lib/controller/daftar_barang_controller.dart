import 'package:cwi_apps/models/product_model.dart';
import 'package:cwi_apps/services/product_repository.dart';

class DaftarBarangController {
  final repo = ProductRepository();

  Future<List<ProductModel>> getAllBarang() async {
    return await repo.getAllProducts();
  }
}
