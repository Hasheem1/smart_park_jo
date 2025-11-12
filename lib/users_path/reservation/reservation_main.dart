import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../active reservation/active_reservation.dart';

class ReserveSpotScreen extends StatefulWidget {
  const ReserveSpotScreen({super.key});

  @override
  State<ReserveSpotScreen> createState() => _ReserveSpotScreenState();
}

class _ReserveSpotScreenState extends State<ReserveSpotScreen>
    with SingleTickerProviderStateMixin {
  int duration = 2;
  double pricePerHour = 2.5;
  final TextEditingController plateController = TextEditingController();

  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeInAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double totalCost = duration * pricePerHour;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F6FF),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
        title: const Text(
          "Reserve Spot",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeInAnimation,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _modernCard(
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            CupertinoIcons.location_solid,
                            color: Color(0xFF007BFF),
                          ),
                        ),
                        title: const Text(
                          "City Center Parking",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        subtitle: const Text(
                          "2.5 JOD / hour",
                          style: TextStyle(color: Colors.grey),
                        ),
                        trailing: const Icon(
                          CupertinoIcons.map_pin_ellipse,
                          color: Color(0xFF007BFF),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    _modernCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Duration",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              _circleButton(
                                icon: Icons.remove,
                                onTap: () {
                                  setState(() {
                                    if (duration > 1) duration--;
                                  });
                                },
                              ),
                              const SizedBox(width: 20),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.time,
                                        color: Colors.blue),
                                    const SizedBox(width: 8),
                                    Text(
                                      "$duration hours",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              _circleButton(
                                icon: Icons.add,
                                onTap: () {
                                  setState(() {
                                    if (duration < 24) duration++;
                                  });
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 10,
                            children: [1, 2, 3, 4, 5, 6, 7, 8].map((h) {
                              bool selected = duration == h;
                              return ChoiceChip(
                                label: Text("${h}h"),
                                selected: selected,
                                onSelected: (_) {
                                  setState(() => duration = h);
                                },
                                selectedColor: const Color(0xFF007BFF),
                                backgroundColor: Colors.grey.shade200,
                                labelStyle: TextStyle(
                                  color: selected
                                      ? Colors.white
                                      : Colors.grey.shade700,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    _modernCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Car Plate Number",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: plateController,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(
                                  CupertinoIcons.car_detailed,
                                  color: Colors.blue),
                              hintText: "Enter plate number",
                              filled: true,
                              fillColor: const Color(0xFFF3F6FA),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    _modernCard(
                      color: const Color(0xFF007BFF),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total Cost",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                          Text(
                            "${totalCost.toStringAsFixed(2)} JOD",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // Confirm Button (floating style)
              ElevatedButton.icon(
                onPressed: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => ActiveReservationScreen(),));
                },
                icon: const Icon(CupertinoIcons.checkmark_alt, size: 22),
                label: const Text(
                  "Confirm Reservation",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  backgroundColor: const Color(0xFF00B37A),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 6,
                  shadowColor: Colors.greenAccent.withOpacity(0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- Reusable Widgets ----

  Widget _modernCard({required Widget child, Color? color}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.blue, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.blue),
      ),
    );
  }
}
