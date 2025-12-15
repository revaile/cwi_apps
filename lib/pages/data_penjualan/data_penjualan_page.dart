import 'package:cwi_apps/widgets/btn_widget.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class DataPenjualanPage extends StatelessWidget {
  const DataPenjualanPage({super.key});

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
              // ===== TITLE =====
              const Text(
                'DATA PENJUALAN',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              Row(
                children: const [
                  Text(
                    'Kamis, 14 Januari 2025',
                    style: TextStyle(color: Colors.black54),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.calendar_today, size: 16),
                ],
              ),

              const SizedBox(height: 16),

              // ===== CHART & STAT CARD =====
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // STAT TOP
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        _TopStat(
                          title: 'Barang Terjual',
                          value: '5.000',
                        ),
                        _TopStat(
                          title: 'Paling Laris',
                          value: 'sabun',
                        ),
                      ],
                    ),

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
                              sideTitles:
                                  SideTitles(showTitles: true, reservedSize: 28),
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
                                    'Sat'
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

              // ===== LIST PRODUK =====
              _produkItem(),
              _produkItem(),
              _produkItem(),
              _produkItem(),

              const SizedBox(height: 20),

              // ===== DOWNLOAD BUTTON =====
                BtnWidget(
                onTap: () {},
                // icon: Icons.add,
                width: 350,
                height: 40,
                text: "Downlowad PDF",
                bgcolor: Colors.blue,
                textstyle: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                isUpercase: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =========================
// SMALL COMPONENTS
// =========================

class _TopStat extends StatelessWidget {
  final String title;
  final String value;

  const _TopStat({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.black54),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

Widget _produkItem() {
  return Container(
    margin: const EdgeInsets.only(bottom: 10),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.grey),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Jelly 65gram',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 4),
            Text(
              'Barang Terjual: 250pcs',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ],
    ),
  );
}
