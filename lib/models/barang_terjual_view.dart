class BarangTerjualView {
  final String id;
  final String namaProduk;
  final String namaPembeli;
  final DateTime tanggal;
  final int jumlah;
  final int harga;
  final String imageUrl;
  final String via;


  BarangTerjualView({
    required this.id,
    required this.namaProduk,
    required this.tanggal,
    required this.jumlah,
    required this.harga,
    required this.imageUrl,
    required this.namaPembeli,
    required this.via
  });
}
