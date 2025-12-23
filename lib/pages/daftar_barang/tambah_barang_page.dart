import 'dart:typed_data';

import 'package:cwi_apps/models/category_model.dart';
import 'package:cwi_apps/services/category_repository.dart';
import 'package:cwi_apps/services/storage_repository.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:cwi_apps/models/product_model.dart';
import 'package:cwi_apps/services/product_repository.dart';

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final namaC = TextEditingController();
  final hargaC = TextEditingController();
  final qtyC = TextEditingController();
  // final descC = TextEditingController();
  final tglC = TextEditingController();

  final repo = ProductRepository();
  DateTime? pickedDate;
  String? selectedCategoryId;
  late Future<List<CategoryModel>> futureCategories;
  Uint8List? imageBytes;
  String? imageUrl;
  String? imageId;

  @override
  void initState() {
    super.initState();
    futureCategories = CategoryRepository().getAllCategories();
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
    if (namaC.text.isEmpty ||
        hargaC.text.isEmpty ||
        qtyC.text.isEmpty ||
        pickedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Lengkapi semua data wajib!")),
      );
      return;
    }

    try {
      final product = ProductModel(
        id: '',
        name: namaC.text,
        tanggalMasuk: pickedDate!,
        harga: int.tryParse(hargaC.text) ?? 0,
        jumlah: int.tryParse(qtyC.text) ?? 0,
        imageUrl: imageUrl ?? "",
        imageId: imageId ?? "",
        categoryId: selectedCategoryId,
      );

      await repo.createProduct(product);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Barang berhasil disimpan")));

      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
  }

  Future<void> pickImage() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // penting agar dapat bytes
      );

      if (result == null) return;

      final file = result.files.first;
      imageBytes = file.bytes;

      final storage = StorageRepository();
      final uploaded = await storage.uploadImage(file.path!);

      setState(() {
        imageUrl = uploaded['url'];
        imageId = uploaded['id'];
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Gambar berhasil diupload")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Upload gagal: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      appBar: AppBar(
        title: const Text("Tambah Barang"),
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
              Center(
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: pickImage,
                      child: Container(
                        width: 160,
                        height: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                          color: Colors.grey.shade200,
                          border: Border.all(color: Colors.grey.shade400),
                        ),
                        child: imageUrl == null
                            ? const Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.grey,
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(14),
                                child: Image.network(
                                  imageUrl!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text("Tap untuk memilih gambar"),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              _label("Nama Produk"),
              _input(controller: namaC, hint: "Masukan nama produk"),

              const SizedBox(height: 18),
              _label("Harga Produk"),
              _input(
                controller: hargaC,
                hint: "Masukan harga",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 18),
              _label("Jumlah / Stok"),
              _input(
                controller: qtyC,
                hint: "Masukan jumlah stok",
                keyboard: TextInputType.number,
              ),

              const SizedBox(height: 18),
              _label("Tanggal Masuk"),
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

              const SizedBox(height: 18),

              const SizedBox(height: 18),
              _label("Kategori Produk"),

              FutureBuilder(
                future: futureCategories,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final categories = snapshot.data!;

                  return DropdownButtonFormField<String>(
                    value: selectedCategoryId,
                    items: categories.map((c) {
                      return DropdownMenuItem(value: c.id, child: Text(c.name));
                    }).toList(),
                    onChanged: (v) {
                      setState(() {
                        selectedCategoryId = v;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
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
  }) {
    return TextField(
      controller: controller,
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
