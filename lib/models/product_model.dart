class ProductModel {
  final String id;
  final String name;
  final DateTime tanggalMasuk;
  final int harga;
  final int jumlah;
  // final String? deskripsi;
  final String imageUrl;
  final String imageId;
  final String? categoryId;

  ProductModel({
    required this.id,
    required this.name,
    required this.tanggalMasuk,
    required this.harga,
    required this.jumlah,
    // required this.deskripsi,
    required this.imageUrl,
    required this.imageId,
    this.categoryId,
  });

  factory ProductModel.fromAppwrite(Map<String, dynamic> json) {
    return ProductModel(
      id: json['\$id'],
      name: json['nama_produk'],
      tanggalMasuk: DateTime.parse(json['tgl_masuk']),
      harga: int.tryParse(json['harga_produk'].toString()) ?? 0,
      jumlah: int.tryParse(json['jumlah_produk'].toString()) ?? 0,
      // deskripsi: json['desc_produk'],      // 👈 ambil langsung
      imageUrl: json['image_url'] ?? "",
      imageId: json['image_id'] ?? "",
      categoryId: json['category'], // <-- TAMBAH INI
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama_produk': name,
      'tgl_masuk': tanggalMasuk.toIso8601String(),
      'harga_produk': harga,
      'jumlah_produk': jumlah,
      // 'desc_produk': deskripsi,            // 👈 simpan balik
      'image_url': imageUrl,
      'image_id': imageId,
      'category': categoryId, // <-- TAMBAH INI
    };
  }
}
