import 'package:flutter/material.dart';

class ManageSpotsScreen extends StatefulWidget {
  final String parkingId;
  final Map<String, dynamic> parkingData;

  const ManageSpotsScreen({
    super.key,
    required this.parkingId,
    required this.parkingData,
  });

  @override
  State<ManageSpotsScreen> createState() => _ManageSpotsScreenState();
}

class _ManageSpotsScreenState extends State<ManageSpotsScreen> {
  String selectedFilter = "All";
  late List<Map<String, dynamic>> spots;

  @override
  void initState() {
    super.initState();

    int capacity = widget.parkingData['Parking Capacity'];

    // Generate spots based on capacity
    spots = List.generate(capacity, (index) {
      return {
        "id": "A${(index + 1).toString().padLeft(2, '0')}",
        "status": "Available",
      };
    });
  }

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
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      icon:
                      const Icon(Icons.arrow_back, color: Colors.white),
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

                // SUMMARY CARDS
                Row(
                  children: [
                    _summaryCard("Available", availableCount),
                    const SizedBox(width: 12),
                    _summaryCard("Occupied", occupiedCount),
                  ],
                ),
                const SizedBox(height: 20),

                // FILTER BUTTONS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _filterButton("All"),
                    _filterButton("Available"),
                    _filterButton("Occupied"),
                  ],
                ),
                const SizedBox(height: 20),

                // SPOTS GRID
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
                    final isAvailable =
                        spot["status"] == "Available";

                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                spot["id"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Switch(
                                value: isAvailable,
                                onChanged: (value) {
                                  setState(() {
                                    spot["status"] = value
                                        ? "Available"
                                        : "Occupied";
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            spot["status"],
                            style: TextStyle(
                              color: isAvailable
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFC62828),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
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
    );
  }

  Widget _summaryCard(String title, int value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 8),
            Text(
              "$value",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterButton(String label) {
    final bool isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
            colors: [Color(0xFF1565C0), Color(0xFF42A5F5)],
          )
              : null,
          color: !isSelected ? Colors.white24 : null,
          borderRadius: BorderRadius.circular(20),
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
