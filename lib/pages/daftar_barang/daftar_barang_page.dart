import 'package:cwi_apps/controller/daftar_barang_controller.dart';
import 'package:cwi_apps/widgets/btn_widget.dart';
import 'package:cwi_apps/widgets/daftar_barang_card.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class DaftarBarang extends StatefulWidget {
  const DaftarBarang({super.key});

  @override
  State<DaftarBarang> createState() => _DaftarBarangState();
}

class _DaftarBarangState extends State<DaftarBarang> {
  final controller = DaftarBarangController();
  late Future future;

  @override
  void initState() {
    super.initState();
    future = controller.getAllBarang();
  }

  void refresh() {
    setState(() {
      future = controller.getAllBarang();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Daftar Barang"),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          color: Colors.black,
        ),
        backgroundColor: Color(0xFFC6EFE7),
        elevation: 0,
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              /// ================= LIST PRODUK =================
              FutureBuilder(
                future: controller.getAllBarang(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final data = snapshot.data!;

                  if (data.isEmpty) {
                    return const Center(child: Text("Belum ada barang"));
                  }

                  return Column(
                    children: data.map((p) {
                      final tanggal = DateFormat(
                        'd MMMM yyyy',
                        'id_ID',
                      ).format(p.tanggalMasuk);

                      return DaftarBarangCard(
                        productId: p.id,
                        namaProduk: p.name,
                        imageUrl: p.imageUrl,
                        tanggalMasuk: tanggal,
                        qty: p.jumlah,
                        unit: "Pcs",

                        onOpenDetail: () {
                          Navigator.pushNamed(
                            context,
                            '/detail-barang',
                            arguments: p.id,
                          );
                        },

                        onRefresh: () {
                          setState(() {}); // atau panggil ulang Future
                        },
                      );
                    }).toList(),
                  );
                },
              ),

              /// ================= BUTTON =================
              BtnWidget(
                onTap: () async {
                  final result = await Navigator.pushNamed(
                    context,
                    '/tambah-barang',
                  );

                  if (result == true) {
                    refresh(); // 🔥 UI UPDATE
                  }
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

              const SizedBox(height: 15),

              BtnWidget(
                onTap: () async {
                  final products = await controller.getAllBarang();
                  await generatePdf(products);
                },
                width: 350,
                height: 40,
                text: "Download PDF",
                bgcolor: Colors.blue,
                textstyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                isUpercase: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> generatePdf(List products) async {
  final pdf = pw.Document();

  pdf.addPage(
    pw.MultiPage(
      build: (context) => [
        pw.Center(
          child: pw.Text(
            "DAFTAR BARANG",
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
        ),
        pw.SizedBox(height: 15),

        pw.Table.fromTextArray(
          border: pw.TableBorder.all(),
          cellAlignment: pw.Alignment.centerLeft,
          headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
          headers: ["No", "Nama Barang", "Tanggal Masuk", "Qty", "Unit"],
          data: List.generate(
            products.length,
            (i) => [
              "${i + 1}",
              products[i].name,
              DateFormat(
                'd MMMM yyyy',
                'id_ID',
              ).format(products[i].tanggalMasuk),
              products[i].jumlah.toString(),
              "Pcs",
            ],
          ),
        ),
      ],
    ),
  );

  await Printing.layoutPdf(onLayout: (format) async => pdf.save());
}
