import 'package:flutter/material.dart';



class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  static const Color primaryBlue =    Color(0xFF0F2027);
  static const Color accentGreen = Color(0xFF203A43);
  static const Color background = Color(0xFF0F2027);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Future<void> _refresh() async {
    // placeholder for refresh logic
    await Future<void>.delayed(const Duration(milliseconds: 700));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(138),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryBlue, accentGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 14.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row with back button and optional filter
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      const SizedBox(width: 6),
                      const Expanded(
                        child: Text(
                          'My Bookings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      // Optional small action
                      IconButton(
                        icon: const Icon(Icons.filter_list, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 8), // spacing before tab pill

                  // Tab pill
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicator: BoxDecoration(
                        color: Colors.white.withOpacity(0.26),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      labelColor: Colors.white,
                      unselectedLabelColor: Colors.white70,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                      tabs: const [
                        Tab(text: 'Upcoming'),
                        Tab(text: 'Past'),
                      ],
                    ),
                  ),
                ],
              ),

            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Upcoming - list with pull to refresh
          RefreshIndicator(
            onRefresh: _refresh,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              physics: const AlwaysScrollableScrollPhysics(
                  parent: BouncingScrollPhysics()),
              children: const [
                BookingCard(
                  imageUrl:
                  'https://upload.wikimedia.org/wikipedia/commons/9/90/Mall_parking_lot.jpg',
                  title: 'City Center Mall',
                  dateTime: 'Today • 14:00 - 16:00',
                  duration: '2 hours',
                  price: '4 JD',
                  status: 'Confirmed',
                ),
                BookingCard(
                  imageUrl:
                  'https://upload.wikimedia.org/wikipedia/commons/3/3f/Parking_lot_overview.jpg',
                  title: 'Rainbow Street Parking',
                  dateTime: 'Tomorrow • 10:00 - 12:00',
                  duration: '2 hours',
                  price: '3 JD',
                  status: 'Confirmed',
                ),
                BookingCard(
                  imageUrl: '',
                  title: 'Old Town Parking',
                  dateTime: 'Sat • 09:00 - 11:00',
                  duration: '2 hours',
                  price: '2.5 JD',
                  status: 'Pending',
                ),
              ],
            ),
          ),

          // Past - empty state
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_rounded,
                      size: 72, color: Colors.grey.shade400),
                  const SizedBox(height: 12),
                  Text(
                    'No past bookings',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your finished bookings will appear here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BookingCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String dateTime;
  final String duration;
  final String price;
  final String status;

  const BookingCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.dateTime,
    required this.duration,
    required this.price,
    required this.status,
  });

  static const Color primaryBlue = Color(0xFF2196F3);
  static const Color accentGreen = Color(0xFF2196F3);

  @override
  Widget build(BuildContext context) {
    // Card layout is minimal & clean
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: (imageUrl.isEmpty)
                ? Container(
              width: 76,
              height: 76,
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: Icon(Icons.location_on_outlined,
                  size: 30, color: Colors.grey.shade400),
            )
                : Image.network(
              imageUrl,
              width: 76,
              height: 76,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return Container(
                  width: 76,
                  height: 76,
                  color: Colors.grey.shade100,
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
              errorBuilder: (_, __, ___) => Container(
                width: 76,
                height: 76,
                color: Colors.grey.shade100,
                alignment: Alignment.center,
                child: Icon(Icons.broken_image,
                    size: 28, color: Colors.grey.shade400),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Main info (title + details)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // title and optional tag
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),

                const SizedBox(height: 6),

                // date/time
                Row(
                  children: [
                    Icon(Icons.access_time_rounded,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        dateTime,
                        style: TextStyle(
                            fontSize: 13, color: Colors.grey.shade700),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // duration & spacer
                Row(
                  children: [
                    Icon(Icons.timer_outlined,
                        size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 8),
                    Text(
                      duration,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          // Right column: status badge + price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Status badge (small)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status.toLowerCase() == 'confirmed'
                      ? accentGreen
                      : (status.toLowerCase() == 'pending'
                      ? Colors.orange
                      : Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700),
                ),
              ),

              const SizedBox(height: 12),

              Text(
                price,
                style: const TextStyle(
                    color: primaryBlue,
                    fontSize: 16,
                    fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
