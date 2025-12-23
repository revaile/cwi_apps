import 'package:cwi_apps/pages/barang_masuk/barang_masuk_page.dart';
import 'package:cwi_apps/pages/barang_masuk/detail_barang_masuk_page.dart';
import 'package:cwi_apps/pages/barang_masuk/edit_barang_masuk.dart';
import 'package:cwi_apps/pages/barang_masuk/tambah_barang_masuk.dart';
import 'package:cwi_apps/pages/barang_terjual/barang_terjual_page.dart';
import 'package:cwi_apps/pages/barang_terjual/detail_barang_terjual_page.dart';
import 'package:cwi_apps/pages/barang_terjual/edit_barang_terjual.dart';
import 'package:cwi_apps/pages/barang_terjual/tambah_barang_terjual_page.dart';
import 'package:cwi_apps/pages/daftar_barang/daftar_barang_page.dart';
import 'package:cwi_apps/pages/daftar_barang/detail_barang_page.dart';
import 'package:cwi_apps/pages/daftar_barang/edit_barang_page.dart';
import 'package:cwi_apps/pages/daftar_barang/tambah_barang_page.dart';
import 'package:cwi_apps/pages/data_penjualan/data_penjualan_page.dart';
import 'package:cwi_apps/pages/login_page.dart';
import 'package:cwi_apps/pages/my_home_page.dart';
import 'package:cwi_apps/pages/profil/edit_profil_page.dart';
import 'package:cwi_apps/pages/profil/profil_page.dart';
import 'package:cwi_apps/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cwi Apss',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      
      routes: {
        '/login' : (context)=> LoginPage(),
        '/profil' : (context) => ProfilPage(),
        '/edit-profil' : (context) => EditProfilPage(),
        '/beranda' : (context) => MyHomePage(),
        '/daftar-barang' : (context) => DaftarBarang(),
        '/detail-barang' : (context) => DetailBarangPage(),
        '/tambah-barang' : (context) => TambahBarangPage(),
        '/edit-daftar-barang' : (context) => EditBarangPage(),
        '/barang-terjual' : (context) => BarangTerjualPage(),
        '/tambah-barang-terjual' : (context) => TambahBarangTerjualPage(),
        '/edit-barang-terjual' : (context) => EditBarangTerjual(),
        '/detail-barang-terjual' : (context) => DetailBarangTerjualPage(),
        '/data-penjualan' : (context) => DataPenjualanPage(),
        '/barang-masuk' : (context) => BarangMasukPage(),
        '/detail-barang-masuk' : (context) => DetailBarangMasukPage(),
        '/tambah-barang-masuk' : (context) => TambahBarangMasuk(),
        '/edit-barang-masuk' : (context) => EditBarangMasuk(),
      },
      home: SplashScreen(),
    );
  }
}
