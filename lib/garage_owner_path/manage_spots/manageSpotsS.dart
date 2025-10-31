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
    {"id": "A02", "status": "Occupied", "user": "Ahmad K.", "until": "16:30"},
    {"id": "A03", "status": "Occupied"},
    {"id": "A04", "status": "Available"},
    {"id": "A05", "status": "Available"},
    {"id": "A06", "status": "Occupied", "user": "Ahmad K.", "until": "16:30"},
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

    // filter spots list
    List<Map<String, dynamic>> filteredSpots = spots.where((spot) {
      if (selectedFilter == "All") return true;
      return spot["status"] == selectedFilter;
    }).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Manage Spots",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(scrollbars: false),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // Summary Cards
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.green.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Available",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.green)),
                          const SizedBox(height: 4),
                          Text("$availableCount",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Occupied",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue)),
                          const SizedBox(height: 4),
                          Text("$occupiedCount",
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Filter Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _filterButton("All"),
                  _filterButton("Available"),
                  _filterButton("Occupied"),
                ],
              ),

              const SizedBox(height: 16),

              // Grid of Spots
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredSpots.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.2,
                ),
                itemBuilder: (context, index) {
                  final spot = filteredSpots[index];
                  final isAvailable = spot["status"] == "Available";

                  return Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color:
                      isAvailable ? Colors.green.shade50 : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isAvailable
                            ? Colors.green.shade100
                            : Colors.blue.shade100,
                      ),
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
                              ),
                            ),
                            Switch(
                              value: isAvailable,
                              onChanged: (_) {},
                              activeColor: Colors.green,
                              inactiveThumbColor: Colors.grey,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          spot["status"],
                          style: TextStyle(
                            color: isAvailable ? Colors.green : Colors.blue,
                            fontWeight: FontWeight.w500,
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
