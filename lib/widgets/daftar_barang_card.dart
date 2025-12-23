import 'package:flutter/material.dart';

class DaftarBarangCard extends StatelessWidget {
  final String productId;

  final String namaProduk;
  final String tanggalMasuk;
  final int qty;
  final String unit;
  final String imageUrl; // 👈 TAMBAH INI
  final VoidCallback? onOpenDetail; // 👈 khusus detail
  final VoidCallback? onRefresh;    // 👈 khusus refresh

  const DaftarBarangCard({
    super.key,
    required this.productId,
    required this.namaProduk,
    required this.tanggalMasuk,
    required this.qty,
    required this.unit,
    required this.imageUrl, // 👈 TAMBAH INI
   this.onOpenDetail,
    this.onRefresh,  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   Navigator.pushNamed(context, '/detail-barang', arguments: productId);
      // },
      onTap: onOpenDetail,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================= IMAGE =================
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 80,
                height: 80,
                color: Colors.grey.shade300,
                child: imageUrl.isEmpty
                    ? const Icon(Icons.image_outlined, color: Colors.black54)
                    : Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                              Icons.broken_image,
                              color: Colors.black54,
                            ),
                      ),
              ),
            ),

            const SizedBox(width: 12),

            /// ================= INFO =================
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    namaProduk,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  const Text(
                    "Tanggal Masuk",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                  Text(
                    tanggalMasuk,
                    style: const TextStyle(fontSize: 12, color: Colors.black87),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Text(
                        "Qty",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text("$qty"),

                      const SizedBox(width: 20),

                      const Text(
                        "Unit",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 6),
                      Text(unit),
                    ],
                  ),
                ],
              ),
            ),

            /// ================= BUTTON EDIT =================
            SizedBox(
              height: 35,
              child: ElevatedButton.icon(
                onPressed: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/edit-daftar-barang',
                    arguments: productId,
                  );

                  if (result == true) {
                    onRefresh?.call(); // 🔥 trigger refresh dari parent
                  }
                },

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade100,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.edit, size: 18),
                label: const Text("Edit", style: TextStyle(fontSize: 14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
