import 'package:cwi_apps/models/transaksi_model.dart';
import 'package:cwi_apps/models/product_model.dart';
import 'package:cwi_apps/services/product_repository.dart';
import 'package:cwi_apps/services/transaksi_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TambahBarangMasuk extends StatefulWidget {
  const TambahBarangMasuk({super.key});

  @override
  State<TambahBarangMasuk> createState() =>
      _TambahBarangMasukState();
}

class _TambahBarangMasukState extends State<TambahBarangMasuk> {
  final namaPembeliC = TextEditingController();
  String? selectedVia;
  final hargaC = TextEditingController();
  final qtyC = TextEditingController();
  final tglC = TextEditingController();

  DateTime? pickedDate;

  String? selectedProductId;
  List<ProductModel> products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final repo = ProductRepository();
    final data = await repo.getAllProducts();
    setState(() {
      products = data;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final result = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      pickedDate = result;
      tglC.text = DateFormat('d MMMM yyyy', 'id_ID').format(result);
      setState(() {});
    }
  }

  Future<void> _save() async {
    if (selectedProductId == null ||
        hargaC.text.isEmpty ||
        qtyC.text.isEmpty ||
        pickedDate == null ||
        namaPembeliC.text.isEmpty ||
        selectedVia == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data wajib!")),
      );
      return;
    }

    try {
      final transaksi = TransaksiModel(
        id: '',
        productId: selectedProductId!,
        namaPembeli: namaPembeliC.text,
        tanggal: pickedDate!,
        jumlah: int.tryParse(qtyC.text) ?? 0,
        jenisTransaksi: 'masuk',
        via: selectedVia ?? '',
        harga: int.tryParse(hargaC.text) ?? 0,
      );

      await TransaksiRepository().createBarangMasuk(transaksi);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Barang masuk berhasil diTambahkan")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Tambah Barang Masuk"),
        centerTitle: true,
        backgroundColor: const Color(0xFFC6EFE7),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 18),
              _label("Nama Pembeli"),
              _input(controller: namaPembeliC, hint: "Masukan nama pembeli"),

              const SizedBox(height: 18),
              _label("Nama Produk"),

              DropdownButtonFormField<String>(
                value: selectedProductId,
                items: products.map((p) {
                  return DropdownMenuItem(value: p.id, child: Text(p.name));
                }).toList(),
                onChanged: (v) {
                  setState(() {
                    selectedProductId = v;
                    final selected = products.firstWhere(
                      (element) => element.id == v,
                    );
                    hargaC.text = selected.harga.toString();
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              _label("Transaksi via"),
              DropdownButtonFormField<String>(
                value: selectedVia,
                items: const [
                  DropdownMenuItem(value: "Tiktok", child: Text("Tiktok")),
                  DropdownMenuItem(value: "Shopee", child: Text("Shopee")),
                  DropdownMenuItem(
                    value: "Tokopedia",
                    child: Text("Tokopedia"),
                  ),
                  DropdownMenuItem(value: "Offline", child: Text("Offline")),
                  DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
                ],
                onChanged: (v) {
                  setState(() => selectedVia = v);
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              _label("Harga Produk (Auto dari DB)"),
              _input(
                controller: hargaC,
                hint: "Harga otomatis",
                keyboard: TextInputType.number,
                readOnly: true,
              ),

              const SizedBox(height: 18),
              _label("Jumlah"),
              _input(
                controller: qtyC,
                hint: "Masukan jumlah terjual",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 18),
              _label("Tanggal"),
              TextField(
                controller: tglC,
                readOnly: true,
                onTap: _pickDate,
                decoration: InputDecoration(
                  hintText: "Pilih tanggal...",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  suffixIcon: const Icon(Icons.calendar_month),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "SAVE",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
    ),
  );

  Widget _input({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboard = TextInputType.text,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
