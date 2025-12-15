import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFC6EFE7),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi,",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Staff Gudang",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    // ===== RIGHT AREA =====
                    Row(
                      children: [
                        const Text(
                          "Admin",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(width: 10),

                        // ===== FOTO PROFIL (TAPABLE) =====
                        InkWell(
                          onTap: () {
                            Navigator.pushNamed(context, '/profil');
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
                  _statBox("1.500", "Barang Masuk"),
                  _statBox("5.000", "Barang Terjual"),
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
                              spots: const [
                                FlSpot(0, 10),
                                FlSpot(1, 15),
                                FlSpot(2, 12),
                                FlSpot(3, 25),
                                FlSpot(4, 20),
                                FlSpot(5, 18),
                                FlSpot(6, 22),
                              ],
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 3,
                              dotData: FlDotData(show: false),
                            ),
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 8),
                                FlSpot(1, 10),
                                FlSpot(2, 18),
                                FlSpot(3, 15),
                                FlSpot(4, 12),
                                FlSpot(5, 14),
                                FlSpot(6, 10),
                              ],
                              isCurved: true,
                              color: Colors.cyan,
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
                    onTap: () {
                      print("Barang Masuk diklik");
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
