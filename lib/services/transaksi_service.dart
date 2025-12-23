import 'package:appwrite/appwrite.dart';
import '../services/appwrite_client.dart';
import '../models/transaksi_model.dart';

class TransaksiRepository {
  final _db = AppwriteService.databases;
  final String databaseId = '6944300100059c12c035';


// barang keluar
  Future<List<TransaksiModel>> getBarangTerjual() async {
    final res = await _db.listDocuments(
      databaseId: databaseId,
      collectionId: 'transaksi',
      queries: [
        Query.equal('jenis_transaksi', 'keluar'),
        Query.orderDesc('\$createdAt'),
      ],
    );

    return res.documents
        .map((doc) => TransaksiModel.fromAppwrite(doc.data..['\$id'] = doc.$id))
        .toList();
  }

Future<void> createBarangKeluar(TransaksiModel transaksi) async {
  final data = transaksi.toJson();
  data['jenis_transaksi'] = 'keluar';

  // PENTING → ubah sesuai nama field relasi di Appwrite !!
  // data['productId'] = [transaksi.productId];

  await _db.createDocument(
    databaseId: databaseId,
    collectionId: 'transaksi',
    documentId: ID.unique(),
    data: data,
  );

}
Future<void> updateBarangTerjual(TransaksiModel transaksi) async {
    final data = transaksi.toJson();
  data['jenis_transaksi'] = 'keluar';
  await _db.updateDocument(
    databaseId: databaseId,
    collectionId: 'transaksi',
    documentId: transaksi.id,     // WAJIB pakai id
    data: transaksi.toJson(),
  );
}

Future<TransaksiModel> getById(String id) async {
  final res = await _db.getDocument(
    databaseId: databaseId,
    collectionId: 'transaksi',
    documentId: id,
  );

  return TransaksiModel.fromAppwrite(
    res.data..['\$id'] = res.$id
  );
}
Future<void> deleteTransaksi(String id) async {
  await _db.deleteDocument(
    databaseId: databaseId,
    collectionId: 'transaksi',
    documentId: id,
  );
}

// end
// barang masuk

  Future<List<TransaksiModel>> getBarangMasuk() async {
    final res = await _db.listDocuments(
      databaseId: databaseId,
      collectionId: 'transaksi',
      queries: [
        Query.equal('jenis_transaksi', 'masuk'),
        Query.orderDesc('\$createdAt'),
      ],
    );


    return res.documents
        .map((doc) => TransaksiModel.fromAppwrite(doc.data..['\$id'] = doc.$id))
        .toList();
  }
  
  Future<void> createBarangMasuk(TransaksiModel transaksi) async {
  final data = transaksi.toJson();
  data['jenis_transaksi'] = 'masuk';

  // PENTING → ubah sesuai nama field relasi di Appwrite !!
  // data['productId'] = [transaksi.productId];

  await _db.createDocument(
    databaseId: databaseId,
    collectionId: 'transaksi',
    documentId: ID.unique(),
    data: data,
  );

}

Future<void> updateBarangMasuk(TransaksiModel transaksi) async {
    final data = transaksi.toJson();
  data['jenis_transaksi'] = 'masuk';
  await _db.updateDocument(
    databaseId: databaseId,
    collectionId: 'transaksi',
    documentId: transaksi.id,     // WAJIB pakai id
    data: transaksi.toJson(),
  );
}

int barangMasuk = 0;
int barangTerjual = 0;
bool loadingStat = true;

// home page
Future<Map<String, int>> getStatistik() async {
  final masuk = await _db.listDocuments(
    databaseId: databaseId,
    collectionId: 'transaksi',
    queries: [Query.equal('jenis_transaksi', 'masuk')],
  );

  final keluar = await _db.listDocuments(
    databaseId: databaseId,
    collectionId: 'transaksi',
    queries: [Query.equal('jenis_transaksi', 'keluar')],
  );

  return {
    'masuk': masuk.total,
    'keluar': keluar.total,
  };
}

Future<Map<int, int>> getChartBarangTerjual7Hari() async {
  final res = await _db.listDocuments(
    databaseId: databaseId,
    collectionId: 'transaksi',
    queries: [
      Query.equal('jenis_transaksi', 'keluar'),
      Query.limit(100), // amanin
      Query.orderDesc('\$createdAt'),
    ],
  );

  final list = res.documents
      .map((doc) => TransaksiModel.fromAppwrite(doc.data..['\$id'] = doc.$id))
      .toList();

  // siapkan map untuk 7 hari: 0..6
  final Map<int, int> data = {
    0: 0,
    1: 0,
    2: 0,
    3: 0,
    4: 0,
    5: 0,
    6: 0,
  };

  for (final t in list) {
    final hari = t.tanggal.weekday; // 1..7
    final index = (hari - 1);        // 0..6
    data[index] = (data[index] ?? 0) + t.jumlah;
  }

  return data;
}

}
