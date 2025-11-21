import 'package:flutter/material.dart';

class ManageSpotsScreen extends StatefulWidget {
  const ManageSpotsScreen({super.key});

  @override
  State<ManageSpotsScreen> createState() => _ManageSpotsScreenState();
}

class _ManageSpotsScreenState extends State<ManageSpotsScreen> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> spots = [
    {"id": "A01", "status": "Available"},
    {"id": "A02", "status": "Occupied"},
    {"id": "A03", "status": "Occupied"},
    {"id": "A04", "status": "Available"},
    {"id": "A05", "status": "Available"},
    {"id": "A06", "status": "Occupied"},
    {"id": "A07", "status": "Occupied"},
    {"id": "A08", "status": "Available"},
    {"id": "A09", "status": "Available"},
    {"id": "A10", "status": "Available"},
  ];

  @override
  Widget build(BuildContext context) {
    final availableCount =
        spots.where((spot) => spot["status"] == "Available").length;
    final occupiedCount =
        spots.where((spot) => spot["status"] == "Occupied").length;

    List<Map<String, dynamic>> filteredSpots = spots.where((spot) {
      if (selectedFilter == "All") return true;
      return spot["status"] == selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.transparent, // remove default color
      body: Container(
        height: double.infinity, // fill entire screen
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior().copyWith(scrollbars: false),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // AppBar replacement
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Manage Spots",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Summary Cards
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Available",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "$availableCount",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Occupied",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "$occupiedCount",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Filter Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _filterButton("All"),
                      _filterButton("Available"),
                      _filterButton("Occupied"),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Grid of Spots
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredSpots.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.2,
                    ),
                    itemBuilder: (context, index) {
                      final spot = filteredSpots[index];
                      final isAvailable = spot["status"] == "Available";

                      Color cardColor = isAvailable
                          ? Colors.white.withOpacity(0.9)
                          : Colors.grey.shade200;

                      Color statusColor = isAvailable
                          ? const Color(0xFF42A5F5)
                          : const Color(0xFF1565C0);

                      return Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  spot["id"],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black87,
                                  ),
                                ),
                                Switch(
                                  value: isAvailable,
                                  onChanged: (_) {},
                                  activeThumbColor: statusColor,
                                  inactiveThumbColor: Colors.grey,
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              spot["status"],
                              style: TextStyle(
                                color: statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (!isAvailable && spot["user"] != null) ...[
                              const SizedBox(height: 6),
                              Text(
                                spot["user"],
                                style: const TextStyle(color: Colors.black87),
                              ),
                              Text(
                                "Until ${spot["until"]}",
                                style: const TextStyle(color: Colors.black54),
                              ),
                            ]
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- Helper Widget ---
  Widget _filterButton(String label) {
    final bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          )
              : null,
          color: isSelected ? null : Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.black26.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
          ],
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
