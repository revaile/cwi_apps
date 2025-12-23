import 'package:cwi_apps/models/barang_terjual_view.dart';
import 'package:cwi_apps/services/product_repository.dart';
import 'package:cwi_apps/services/transaksi_service.dart';

class BarangTerjualController {
  final transaksiRepo = TransaksiRepository();
  final productRepo = ProductRepository();

  Future<List<BarangTerjualView>> getBarangTerjual() async {
    final transaksiList = await transaksiRepo.getBarangTerjual();

    return Future.wait(
      transaksiList.map((t) async {
        final product = await productRepo.getProduct(t.productId);

        return BarangTerjualView(
          id: t.id,
          namaProduk: product.name,
          tanggal: t.tanggal,
          jumlah: t.jumlah,
          harga: product.harga,
          imageUrl: product.imageUrl,
          namaPembeli: t.namaPembeli,
          via: t.via
        );
      }),
    );
  }
}
