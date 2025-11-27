import 'package:flutter/material.dart';

class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});
  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  int selectedTab = 0;
  // 0 for Upcoming,
  // 1 for Past
  // Sample data for bookings
  final List<Map<String, dynamic>> _upcomingBookings = [
    {
      'location': 'City Center Mall',
      'date': 'Today',
      'time': '14:00 - 16:00',
      'duration': '2 hours',
      'spot': 'A15',
      'price': '4 JD',
      'status': 'Confirmed',
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    },
    {
      'location': 'Rainbow Street Parking',
      'date': 'Tomorrow',
      'time': '10:00 - 12:00',
      'duration': '2 hours',
      'spot': 'B08',
      'price': '3 JD',
      'status': 'Confirmed',
      'imageUrl':
          'https://images.unsplash.com/photo-1506905925346-21bda4d32df4?w=400',
    },
  ];
  final List<Map<String, dynamic>> _pastBookings = [
    {
      'location': 'City Center Mall',
      'date': 'Today',
      'time': '14:00 - 16:00',
      'duration': '2 hours',
      'spot': 'A15',
      'price': '4 JD',
      'status': 'Confirmed',
      'imageUrl':
          'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
    },
  ];
  @override
  Widget build(BuildContext context) {
    final bookings = selectedTab == 0 ? _upcomingBookings : _pastBookings;
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'My Bookings',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(child: _buildTabButton('Upcoming', 0)),
                Expanded(child: _buildTabButton('Past', 1)),
              ],
            ),
          ),
          Expanded(
            child:
                bookings.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.event_busy,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No ${selectedTab == 0 ? 'upcoming' : 'past'} bookings',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: BookingCard(booking: bookings[index],isSelected: selectedTab,),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final isSelected = selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.transparent,
          gradient:
              isSelected
                  ? LinearGradient(
                    colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
                  )
                  : LinearGradient(colors: [Colors.transparent]),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: 16,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final Map<String, dynamic> booking;
  final int isSelected;
  const BookingCard({
    super.key,
    required this.booking,
    required this.isSelected

  });
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            booking['imageUrl'] as String,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[300],
                                child: const Icon(
                                  Icons.local_parking,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['location'] as String,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${booking['date'] as String} • ${booking['time'] as String}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  booking['duration'] as String,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.green[50],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Spot: ${booking['spot'] as String}',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.green[700],
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        booking['status'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue[700],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      booking['price'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF36D1DC), Color(0xFF5B86E5)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: ElevatedButton.icon(
              onPressed: () {
                if (isSelected == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Showing QR Code for ${booking['location']}',
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Rated accept'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },

              icon: isSelected==0? Icon(Icons.qr_code, size: 20):Icon(Icons.star_rate_sharp, size: 20),
              label: isSelected==0? Text(
                'Show QR Code',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ):Text(
                'Rate This Parking',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
