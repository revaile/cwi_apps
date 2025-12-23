import 'package:cwi_apps/models/category_model.dart';
import 'package:cwi_apps/models/product_model.dart';
import 'package:cwi_apps/services/category_repository.dart';
import 'package:cwi_apps/services/product_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailBarangPage extends StatelessWidget {
  const DetailBarangPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String productId =
        ModalRoute.of(context)!.settings.arguments as String;

    final repo = ProductRepository();
    final categoryRepo = CategoryRepository();

    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Detail Barang"),
        centerTitle: true,
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),

      body: FutureBuilder(
        future: Future.wait([
          repo.getProduct(productId),
          categoryRepo.getAllCategories(),
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final item = snapshot.data![0] as ProductModel;
          final List<CategoryModel> categories =
              snapshot.data![1] as List<CategoryModel>;

          final categoryName = categories
              .firstWhere(
                (c) => c.id == item.categoryId,
                orElse: () =>
                    CategoryModel(id: '-', name: 'Tidak ada kategori'),
              )
              .name;

          final tanggal = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).format(item.tanggalMasuk);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                children: [
                  /// ===== HEADER =====
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// IMAGE
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey.shade300,
                          child: item.imageUrl.isEmpty
                              ? const Icon(Icons.image_outlined)
                              : Image.network(
                                  item.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      /// TEXT
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.id,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tanggal,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(item.name),
                            Text(
                              '${item.jumlah} Pcs',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const Divider(height: 28),

                  /// ===== DETAIL =====
                  _detailRow('ID Produk', item.id),
                  _detailRow('Nama Produk', item.name),
                  _detailRow('Category Produk', categoryName),
                  _detailRow('Tanggal Masuk', tanggal),
                  _detailRow('Harga', 'Rp ${item.harga}'),
                  _detailRow('Qty', '${item.jumlah}'),
                  _detailRow('Unit', 'Pcs'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _detailRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: Text(title, style: const TextStyle(fontSize: 13)),
          ),
          const Text(':  '),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
