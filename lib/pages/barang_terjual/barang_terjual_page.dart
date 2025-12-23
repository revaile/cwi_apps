import 'package:cwi_apps/controller/barang_terjual_controller.dart';
import 'package:cwi_apps/widgets/barang_terjual_widget.dart';
import 'package:cwi_apps/widgets/btn_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarangTerjualPage extends StatefulWidget {
  const BarangTerjualPage({super.key});

  @override
  State<BarangTerjualPage> createState() => _BarangTerjualPageState();
}

class _BarangTerjualPageState extends State<BarangTerjualPage> {
  @override
  Widget build(BuildContext context) {
    final controller = BarangTerjualController();
    late Future future;

    @override
    void initState() {
      super.initState();
      future = controller.getBarangTerjual();
    }

    void refresh() {
      setState(() {
        future = controller.getBarangTerjual();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Barang Terjual"),
        centerTitle: true,
        backgroundColor: const Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: controller.getBarangTerjual(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.data!.isEmpty) {
                  return const Center(child: Text("Belum ada barang terjual"));
                }

                final data = snapshot.data!;

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];

                    final tanggalFormatted = DateFormat(
                      'd MMMM yyyy',
                      'id_ID',
                    ).format(item.tanggal);

                    return BarangTerjualWidget(
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/detail-barang-terjual',
                          arguments: item.id,
                        );

                        if (result == true) {
                          refresh(); // 🔥 refresh list setelah hapus / edit
                        }
                      },
                      id: item.id,
                      tanggal: tanggalFormatted,
                      namaProduk: item.namaProduk,
                      jumlah: item.jumlah,
                      total: item.harga,
                      imageUrl: item.imageUrl,
                    );
                  },
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                BtnWidget(
         onTap: () async {
                await Navigator.pushNamed(context, '/tambah-barang-terjual');

                // 🔥 REFRESH SAAT KEMBALI
                refresh();
              },
                  width: 350,
                  height: 40,
                  text: "Tambah Barang",
                  bgcolor: Colors.blue,
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
  }
}
