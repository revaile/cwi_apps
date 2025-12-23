class TransaksiModel {
  final String id;
  final String productId;
  final DateTime tanggal;
  final int jumlah;
  final String jenisTransaksi;
  final String namaPembeli;
  final String via;
  final int harga;

  TransaksiModel({
    required this.id,
    required this.productId,
    required this.tanggal,
    required this.jumlah,
    required this.jenisTransaksi,
    required this.namaPembeli,
    required this.via,
    required this.harga,
  });

  factory TransaksiModel.fromAppwrite(Map<String, dynamic> json) {
    return TransaksiModel(
      id: json['\$id'],
      productId: json['nama_produk'],
      namaPembeli: json['nama_pembeli'],
      tanggal: DateTime.parse(json['tanggal']),
      jumlah: int.tryParse(json['jumlah'].toString()) ?? 0,
      jenisTransaksi: json['jenis_transaksi'] ?? '',
      via: json['transaksi_via'] ?? '',
      harga: int.tryParse(json['harga_produk'].toString()) ?? 0,
    );
  }

  /// 🔥 Dipakai saat create / update ke Appwrite
  Map<String, dynamic> toJson() {
    return {
      'nama_produk': productId,
      'nama_pembeli': namaPembeli,
      'tanggal': tanggal.toIso8601String(),
      'jumlah': jumlah,
      'jenis_transaksi': jenisTransaksi,
      'transaksi_via': via,
      'harga_produk': productId, // <-- WAJIB dikirim
    };
  }

  static fromJson(Map<String, dynamic> map) {}
}
