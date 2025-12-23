import 'package:cwi_apps/models/transaksi_model.dart';
import 'package:cwi_apps/models/product_model.dart';
import 'package:cwi_apps/services/product_repository.dart';
import 'package:cwi_apps/services/transaksi_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EditBarangMasuk extends StatefulWidget {
  const EditBarangMasuk({super.key});

  @override
  State<EditBarangMasuk> createState() => _EditBarangMasukState();
}

class _EditBarangMasukState extends State<EditBarangMasuk> {
  final namaPembeliC = TextEditingController();
  final hargaC = TextEditingController();
  final qtyC = TextEditingController();
  final tglC = TextEditingController();

  String? selectedVia;
  String? selectedProductId;

  DateTime? pickedDate;

  List<ProductModel> products = [];
  TransaksiModel? transaksiData;

  bool isReady = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await _loadProducts();
    await _loadTransaksi();
    setState(() {
      isReady = true;
    });
  }

  Future<void> _loadProducts() async {
    products = await ProductRepository().getAllProducts();
  }

  Future<void> _loadTransaksi() async {
    final String id = ModalRoute.of(context)!.settings.arguments as String;
    final data = await TransaksiRepository().getById(id);

    transaksiData = data;

    selectedProductId = data.productId;
    namaPembeliC.text = data.namaPembeli;
    qtyC.text = data.jumlah.toString();
    hargaC.text = data.harga.toString(); // ⬅️ HARGA FIX
    selectedVia = data.via;
    pickedDate = data.tanggal;
    tglC.text = DateFormat('d MMMM yyyy', 'id_ID').format(data.tanggal);
  }

  Future<void> _pickDate() async {
    final result = await showDatePicker(
      context: context,
      initialDate: pickedDate ?? DateTime.now(),
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

    final old = transaksiData!;

    final transaksi = TransaksiModel(
      id: old.id,
      productId: selectedProductId!,
      namaPembeli: namaPembeliC.text,
      tanggal: pickedDate!,
      jumlah: int.parse(qtyC.text),
      jenisTransaksi: 'masuk',
      via: selectedVia!,
      harga: int.parse(hargaC.text),
    );

    await TransaksiRepository().updateBarangMasuk(transaksi);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Berhasil diupdate")),
    );

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    if (!isReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Edit Barang Masuk"),
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
              _label("Nama Pembeli"),
              _input(controller: namaPembeliC, hint: "Masukan nama pembeli"),

              const SizedBox(height: 18),
              _label("Nama Produk"),
              DropdownButtonFormField<String>(
                value: products.any((p) => p.id == selectedProductId)
                    ? selectedProductId
                    : null,
                items: products
                    .map((p) =>
                        DropdownMenuItem(value: p.id, child: Text(p.name)))
                    .toList(),
                onChanged: (v) {
                  setState(() => selectedProductId = v);
                },
                decoration: _decoration(),
              ),

              const SizedBox(height: 18),
              _label("Transaksi via"),
              DropdownButtonFormField<String>(
                value: ["Tiktok", "Shopee", "Tokopedia", "Offline", "Lainnya"]
                        .contains(selectedVia)
                    ? selectedVia
                    : null,
                items: const [
                  DropdownMenuItem(value: "Tiktok", child: Text("Tiktok")),
                  DropdownMenuItem(value: "Shopee", child: Text("Shopee")),
                  DropdownMenuItem(
                      value: "Tokopedia", child: Text("Tokopedia")),
                  DropdownMenuItem(value: "Offline", child: Text("Offline")),
                  DropdownMenuItem(value: "Lainnya", child: Text("Lainnya")),
                ],
                onChanged: (v) => setState(() => selectedVia = v),
                decoration: _decoration(),
              ),

              // const SizedBox(height: 18),
              // _label("Harga Produk"),
              // _input(
              //   controller: hargaC,
              //   hint: "Harga otomatis",
              //   keyboard: TextInputType.number,
              //   readOnly: true,
              // ),

              const SizedBox(height: 18),
              _label("Jumlah"),
              _input(
                controller: qtyC,
                hint: "Masukan jumlah barang masuk",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 18),
              _label("Tanggal"),
              TextField(
                controller: tglC,
                readOnly: true,
                onTap: _pickDate,
                decoration: _decoration(
                  suffix: const Icon(Icons.calendar_month),
                ).copyWith(hintText: "Pilih tanggal..."),
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

  InputDecoration _decoration({Widget? suffix}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade100,
      suffixIcon: suffix,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
      decoration: _decoration().copyWith(hintText: hint),
    );
  }
}
