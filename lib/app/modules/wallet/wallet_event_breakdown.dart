import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wallet_event_controller.dart';

class WalletEventBreakdownScreen extends StatelessWidget {
  const WalletEventBreakdownScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WalletEventController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6),
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2F2F2F)),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF2F2F2F),
                ),
                onPressed: () {},
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFF3D9C0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.filter_alt, color: Color(0xFF2F2F2F)),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 12, 24, 20),
              child: Text(
                'Wallet Event\nBreakdown',
                style: TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2F2F2F),
                  height: 1.02,
                ),
              ),
            ),

            // Tabs
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Obx(() {
                final idx = controller.currentTabIndex.value;
                return Row(
                  children: [
                    _PillTab(
                      title: 'History',
                      isSelected: idx == 0,
                      onTap: () => controller.changeTab(0),
                    ),
                    const SizedBox(width: 12),
                    _PillTab(
                      title: 'Analytics',
                      isSelected: idx == 1,
                      onTap: () => controller.changeTab(1),
                    ),
                    const SizedBox(width: 12),
                    _PillTab(
                      title: 'Upcoming',
                      isSelected: idx == 2,
                      onTap: () => controller.changeTab(2),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 18),

            // Event list
            Expanded(
              child: Obx(() {
                final events = controller.events;
                return ListView.builder(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  itemCount: events.length + 1,
                  itemBuilder: (context, i) {
                    if (i == events.length) {
                      return const SizedBox(height: 110);
                    }
                    final e = events[i];
                    final bgColor = _bgForSeed(e.colorSeed);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: GestureDetector(
                        onTap: () => controller.onEventTap(e),
                        child: Container(
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.fromLTRB(22, 18, 18, 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          e.dateLabel,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Colors.black.withOpacity(
                                              0.45,
                                            ),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          e.title,
                                          style: const TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF2F2F2F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (e.status == 1)
                                    const Icon(
                                      Icons.check_circle,
                                      color: Colors.grey,
                                    )
                                  else
                                    const SizedBox.shrink(),
                                ],
                              ),
                              const SizedBox(height: 14),
                              const Text(
                                'Amount Collected',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF707978),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '\$${_formatAmount(e.amount)}',
                                    style: const TextStyle(
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF2F2F2F),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  // participant avatars
                                  Row(
                                    children: [
                                      for (var p in e.participants)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 6.0,
                                          ),
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: Colors.white,
                                            child: Text(
                                              p,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                        ),
                                      if (e.extraParticipants > 0)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                          ),
                                          child: CircleAvatar(
                                            radius: 14,
                                            backgroundColor: const Color(
                                              0xFF2F2F2F,
                                            ),
                                            child: Text(
                                              '+${e.extraParticipants}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: e.progress,
                                  minHeight: 6,
                                  backgroundColor: Colors.black.withOpacity(
                                    0.08,
                                  ),
                                  valueColor: AlwaysStoppedAnimation(
                                    Colors.black87,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
      // Bottom navigation and FAB removed per request
    );
  }

  String _formatAmount(double a) {
    return a
        .toStringAsFixed(2)
        .replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => ',');
  }

  Color _bgForSeed(int seed) {
    switch (seed % 3) {
      case 0:
        return const Color(0xFFD9F2EE);
      case 1:
        return const Color(0xFFF0E6F6);
      default:
        return const Color(0xFFFFF0E0);
    }
  }
}

class _PillTab extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _PillTab({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF2F2F2F) : const Color(0xFFF3F3F3),
          borderRadius: BorderRadius.circular(28),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF707978),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      color: const Color(0xFF2F2F2F),
      child: SizedBox(
        height: 72,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.home, color: Colors.white),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.credit_card, color: Colors.white24),
            ),
            const SizedBox(width: 48),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.pie_chart_outline, color: Colors.white24),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none, color: Colors.white24),
            ),
          ],
        ),
      ),
    );
  }
}
