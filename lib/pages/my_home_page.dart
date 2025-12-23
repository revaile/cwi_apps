import 'package:appwrite/models.dart' hide Row;
import 'package:cwi_apps/services/appwrite_client.dart';
import 'package:cwi_apps/services/transaksi_service.dart';
import 'package:cwi_apps/services/user_services.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User? user;
  bool loading = true;
  int barangMasuk = 0;
  int barangTerjual = 0;
  String username = "";
  List<FlSpot> chartKeluar = [];

  final repo = TransaksiRepository();

  @override
  void initState() {
    super.initState();
    getUser();
    getData();
    getUsername(); // 🔥 ambil username
    getChartData(); // 🔥 ini chartnya
  }

  Future<void> getData() async {
    final result = await repo.getStatistik();

    setState(() {
      barangMasuk = result['masuk']!;
      barangTerjual = result['keluar']!;
      loading = false;
    });
  }

  Future<void> getUsername() async {
    final profile = await UserServices().getUserProfile();
    setState(() {
      username = profile.username; // <-- dari field DB
    });
  }

  Future<void> getUser() async {
    try {
      final data = await AppwriteService.account.get();
      setState(() {
        user = data;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  Future<void> getChartData() async {
    final map = await repo.getChartBarangTerjual7Hari();

    setState(() {
      chartKeluar = map.entries
          .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await getUser(); // kalau ga perlu refresh user, boleh hapus
            await getData(); // 🔥 ini refresh statistik
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // HEADER CARD
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // ===== TEXT LEFT =====
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hi,",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 4),

                          Text(
                            loading
                                ? "Loading..."
                                : (user?.name.isNotEmpty == true
                                      ? user!.name
                                      : user?.email ?? "User"),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),

                      // ===== RIGHT AREA =====
                      Row(
                        children: [
                          Text(
                            loading
                                ? "Loading..."
                                : (username.isNotEmpty ? username : "User"),
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),

                          const SizedBox(width: 10),

                          // ===== FOTO PROFIL (TAPABLE) =====
                          InkWell(
                            onTap: () async {
                              final result = await Navigator.pushNamed(
                                context,
                                '/profil',
                              );

                              if (result == true) {
                                await getUser(); // 🔥 REFRESH USER
                              }
                            },

                            borderRadius: BorderRadius.circular(30),
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundColor: Colors.grey.shade300,
                                  child: const Icon(
                                    Icons.person,
                                    color: Colors.white,
                                  ),
                                  // backgroundImage: NetworkImage("https://foto-url"),
                                ),

                                // // ===== STATUS DOT =====
                                // Container(
                                //   width: 10,
                                //   height: 10,
                                //   decoration: BoxDecoration(
                                //     color: Colors.green,
                                //     shape: BoxShape.circle,
                                //     border: Border.all(
                                //       color: Colors.white,
                                //       width: 2,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // STATISTIC BOXES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _statBox("$barangMasuk", "Barang Masuk"),
                    _statBox("$barangTerjual", "Barang Terjual"),
                  ],
                ),

                const SizedBox(height: 20),

                // ===== CHART & STAT CARD =====
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // CHART
                      SizedBox(
                        height: 180,
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 28,
                                ),
                              ),
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) {
                                    const days = [
                                      'Sun',
                                      'Mon',
                                      'Tue',
                                      'Wed',
                                      'Thu',
                                      'Fri',
                                      'Sat',
                                    ];
                                    return Text(
                                      days[value.toInt() % 7],
                                      style: const TextStyle(fontSize: 10),
                                    );
                                  },
                                ),
                              ),
                            ),
                            lineBarsData: [
                              LineChartBarData(
                                spots: chartKeluar.isEmpty
                                    ? const [FlSpot(0, 0)]
                                    : chartKeluar,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                              ),

                              LineChartBarData(
                                spots: chartKeluar.isEmpty
                                    ? const [FlSpot(0, 0)]
                                    : chartKeluar,
                                isCurved: true,
                                color: Colors.blue,
                                barWidth: 3,
                                dotData: FlDotData(show: false),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Menu Admin",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                // MENU GRID
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _menuItem(
                      image: 'assets/ic_chart.png',
                      label: "Barang Masuk",
                      onTap: () async {
                        final result = await Navigator.pushNamed(
                          context,
                          '/barang-masuk',
                        );
                        if (result == true) {
                          getData(); // 🔥 REFRESH STATISTIK
                        }
                      },
                    ),
                    _menuItem(
                      image: 'assets/ic_slod_out.png',
                      label: "Barang Terjual",
                      onTap: () {
                        Navigator.pushNamed(context, '/barang-terjual');
                      },
                    ),
                    _menuItem(
                      image: 'assets/ic_letter_love.png',
                      label: "Daftar Barang",
                      onTap: () {
                        Navigator.pushNamed(context, '/daftar-barang');
                      },
                    ),
                    _menuItem(
                      image: 'assets/ic_letter_money.png',
                      label: "Data Penjualan",
                      onTap: () {
                        Navigator.pushNamed(context, '/data-penjualan');
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// =========================
// COMPONENT WIDGETS
// =========================

Widget _statBox(String value, String label) {
  return Container(
    width: 150,
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    ),
  );
}

class _menuItem extends StatelessWidget {
  final String image;
  final String label;
  final VoidCallback onTap;

  const _menuItem({
    required this.label,
    required this.onTap,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black12),
            ),
            child: Image.asset(image),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
