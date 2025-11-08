import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class EarningsScreen extends StatefulWidget {
  const EarningsScreen({super.key});

  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String selectedTab = "Daily";

  final Map<String, List<double>> chartData = {
    "Daily": [300, 320, 310, 500],
    "Weekly": [1500, 2200, 1800],
    "Monthly": [9200, 9750,],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: const Text(
          "Earnings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true, // <-- This centers the title
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Total This Month Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF66BB6A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.shade200.withOpacity(0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total This Month", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  SizedBox(height: 8),
                  Text("9750 JD", style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text("+12% from last month", style: TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Today & This Week Summary
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatCard("Today", "450 JD", Colors.orangeAccent),
                _buildStatCard("This Week", "2900 JD", Colors.lightBlueAccent),
              ],
            ),
            const SizedBox(height: 25),

            // Tabs
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: ["Daily", "Weekly", "Monthly"].map((tab) {
                  final isSelected = selectedTab == tab;
                  return GestureDetector(
                    onTap: () => setState(() => selectedTab = tab),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 28),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.green.shade50 : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: isSelected
                            ? [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ]
                            : [],
                      ),
                      child: Text(
                        tab,
                        style: TextStyle(
                          color: isSelected ? Colors.green.shade800 : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 25),

            // Chart Label
            Text(
              "$selectedTab Earnings",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            const SizedBox(height: 12),

            // Bar Chart
            Expanded(
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          List<String> labels;
                          if (selectedTab == "Daily") {
                            labels = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];
                          } else if (selectedTab == "Weekly") {
                            labels = ["W1", "W2", "W3", "W4"];
                          } else {
                            labels = ["Jun", "Jul", "Aug", "Sep", "Oct"];
                          }
                          if (value.toInt() < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                labels[value.toInt()],
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  barGroups: _generateBars(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Generate Bar Data
  List<BarChartGroupData> _generateBars() {
    final data = chartData[selectedTab]!;
    return List.generate(
      data.length,
          (index) => BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: data[index],
            gradient: const LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
            width: 22,
            borderRadius: BorderRadius.circular(6),
          ),
        ],
      ),
    );
  }


  // Stat Card
  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Text(title, style: const TextStyle(color: Colors.black54, fontSize: 15)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
