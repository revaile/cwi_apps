import 'package:cwi_apps/controller/barang_masuk_controller.dart';
import 'package:cwi_apps/controller/barang_terjual_controller.dart';
import 'package:cwi_apps/widgets/barang_terjual_widget.dart';
import 'package:cwi_apps/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarangMasukPage extends StatefulWidget {
  const BarangMasukPage({super.key});

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  final controller = BarangMasukController();
  late Future future;

  @override
  void initState() {
    super.initState();
    future = controller.getBarangMasuk();
  }

  void refresh() {
    setState(() {
      future = controller.getBarangMasuk();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Barang Masuk"),
        centerTitle: true,
        backgroundColor: const Color(0xFFC6EFE7),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!;
                if (data.isEmpty) {
                  return const Center(child: Text("Belum ada barang masuk"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return BarangTerjualWidget(
                      id: item.id,
                      tanggal: DateFormat(
                        'd MMMM yyyy',
                        'id_ID',
                      ).format(item.tanggal),
                      namaProduk: item.namaProduk,
                      jumlah: item.jumlah,
                      total: item.harga,
                      imageUrl: item.imageUrl,
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/detail-barang-masuk',
                          arguments: item.id,
                        );

                        if (result == true) {
                          refresh(); // 🔥 refresh list setelah hapus / edit
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),

          /// ================= BUTTON =================
          Padding(
            padding: const EdgeInsets.all(12),
            child: BtnWidget(
              onTap: () async {
                await Navigator.pushNamed(context, '/tambah-barang-masuk');

                // 🔥 REFRESH SAAT KEMBALI
                refresh();
              },
              textstyle: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              width: double.infinity,
              height: 40,
              text: "Tambah Barang",
              bgcolor: Colors.blue,
              isUpercase: true,
            ),
          ),
        ],
      ),
    );
  }
}
