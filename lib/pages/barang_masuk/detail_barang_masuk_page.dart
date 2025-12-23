import 'package:cwi_apps/controller/barang_masuk_controller.dart';
import 'package:cwi_apps/controller/barang_terjual_controller.dart';
import 'package:cwi_apps/services/transaksi_service.dart';
import 'package:cwi_apps/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailBarangMasukPage extends StatelessWidget {
  const DetailBarangMasukPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final controller = BarangMasukController();

    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Detail Barang Masuk"),
        centerTitle: true,
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),

      body: FutureBuilder(
        future: controller.getBarangMasuk(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;
          final item = data.firstWhere((x) => x.id == id);

          final tanggal = DateFormat(
            'd MMMM yyyy',
            'id_ID',
          ).format(item.tanggal);
          final total = item.harga * item.jumlah;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
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
                                Text(item.namaProduk),
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

                          // Text(
                          //   'Rp $total',
                          //   style: const TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 14,
                          //   ),
                          // ),
                        ],
                      ),

                      const Divider(height: 28),

                      /// ===== DETAIL =====
                      _detailRow('Id Transaksi', item.id),
                      _detailRow('Nama Pembeli', item.namaPembeli),
                      _detailRow('Nama Produk', item.namaProduk),
                      _detailRow('Transaki Via', item.via),
                      _detailRow('Tanggal', tanggal),
                      _detailRow('Harga Barang', 'Rp ${item.harga}'),
                      _detailRow('Qty', '${item.jumlah}'),
                      _detailRow('Unit', 'Pcs'),
                      _detailRow('Total Harga', 'Rp $total', isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      BtnWidget(
                          onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/edit-barang-masuk',
                            arguments: item.id,
                          );

                          if (result == true) {
                            Navigator.pop(context, true); // 🔥 TERUSKAN KE LIST
                          }
                        },
                        width: double.infinity,
                        height: 45,
                        text: "Edit Barang",
                        bgcolor: Colors.blue,
                        textstyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        isUpercase: true,
                      ),

                      const SizedBox(height: 10),

                      BtnWidget(
                        onTap: () async {
                          final result = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Hapus Transaksi"),
                              content: const Text(
                                "Yakin ingin menghapus transaksi ini?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text("Batal"),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text("Hapus"),
                                ),
                              ],
                            ),
                          );

                          if (result == true) {
                            await TransaksiRepository().deleteTransaksi(
                              item.id,
                            );

                            //  SNACKBAR SUKSES
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Barang berhasil dihapus"),
                                backgroundColor: Colors.green,
                                duration: Duration(seconds: 2),
                              ),
                            );

                            // ⏪ Kembali ke halaman sebelumnya
                            Navigator.pop(context, true);
                          }
                        },

                        width: double.infinity,
                        height: 45,
                        text: "Hapus Barang",
                        bgcolor: Colors.red,
                        textstyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        isUpercase: true,
                      ),
                    ],
                  ),
                ),
              ],
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
