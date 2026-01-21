import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'wallet_event_details_controller.dart';

class WalletEventDetailsScreen extends StatelessWidget {
  const WalletEventDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(WalletEventDetailsController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Color(0xFF2F2F2F)),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Event Details',
          style: TextStyle(
            color: Color(0xFF2F2F2F),
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F7),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz, color: Color(0xFF2F2F2F)),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 28,
                      horizontal: 20,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F7F8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        // Circular progress
                        SizedBox(
                          height: 120,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 110,
                                height: 110,
                                child: CircularProgressIndicator(
                                  value: c.percent,
                                  strokeWidth: 10,
                                  backgroundColor: const Color(0xFFE9E9EB),
                                  valueColor: AlwaysStoppedAnimation(
                                    const Color(0xFFF6D7A8),
                                  ),
                                ),
                              ),
                              Obx(
                                () => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      '${(c.percent * 100).round()}%',
                                      style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF2F2F2F),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      'FUNDED',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black.withOpacity(0.45),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        Obx(
                          () => Column(
                            children: [
                              Text(
                                c.title.value,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111111),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c.organizer.value,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black.withOpacity(0.45),
                                ),
                              ),
                              const SizedBox(height: 18),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Collected',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.45),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '\$${_fmt(c.collected.value)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 1,
                                    height: 36,
                                    color: Colors.black.withOpacity(0.06),
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Target',
                                        style: TextStyle(
                                          color: Colors.black.withOpacity(0.45),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        '\$${_fmt(c.target.value)}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  // Participants header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Participants',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${c.participants.length} Total',
                        style: TextStyle(color: Colors.black.withOpacity(0.45)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Participant list
                  Column(
                    children: List.generate(c.participants.length, (i) {
                      final p = c.participants[i];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: p.status == 'SETTLED'
                                ? const Color(0xFFEFF9F6)
                                : (p.status == 'PENDING'
                                      ? const Color(0xFFF6F2FF)
                                      : const Color(0xFFF7F7F7)),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.grey.shade300,
                                child: p.avatarUrl == null
                                    ? Text(
                                        p.name
                                            .split(' ')
                                            .map((s) => s[0])
                                            .take(2)
                                            .join(),
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                        ),
                                      )
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      p.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      p.timeLabel,
                                      style: TextStyle(
                                        color: Colors.black.withOpacity(0.45),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '\$${_fmt(p.amount)}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: p.status == 'SETTLED'
                                          ? const Color(0xFFDFF6E9)
                                          : (p.status == 'PENDING'
                                                ? const Color(0xFFFFF0DA)
                                                : const Color(0xFFF0F0F0)),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text(
                                      p.status,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: p.status == 'SETTLED'
                                            ? const Color(0xFF2F8A3E)
                                            : Colors.black87,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 120),
                ],
              ),
            ),
          ),

          // Floating remind pill and small circular button
          Positioned(
            left: 24,
            right: 24,
            bottom: 36,
            child: GestureDetector(
              onTap: c.remindAllPending,
              child: Container(
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF6D7A8),
                  borderRadius: BorderRadius.circular(36),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.notifications_active_outlined,
                      color: Color(0xFF111111),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Remind All Pending',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            right: 18,
            bottom: 18,
            child: Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.nights_stay),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _fmt(double v) => v
      .toStringAsFixed(2)
      .replaceAllMapped(RegExp(r"\B(?=(\d{3})+(?!\d))"), (m) => ',');
}
