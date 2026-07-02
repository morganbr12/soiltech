import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double radius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Shimmer.fromColors(
      baseColor: isDark ? const Color(0xFF1E2E20) : const Color(0xFFE8F0E8),
      highlightColor: isDark ? const Color(0xFF2A3A2A) : const Color(0xFFF5F9F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E2E20) : const Color(0xFFE8F0E8),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const ShimmerBox(width: 52, height: 52, radius: 16),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: double.infinity, height: 14, radius: 6),
                const SizedBox(height: 8),
                ShimmerBox(width: MediaQuery.of(context).size.width * 0.4, height: 12, radius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ShimmerMetricCard extends StatelessWidget {
  const ShimmerMetricCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ShimmerBox(width: 80, height: 12, radius: 6),
              const ShimmerBox(width: 32, height: 32, radius: 10),
            ],
          ),
          const SizedBox(height: 12),
          const ShimmerBox(width: 100, height: 24, radius: 6),
          const SizedBox(height: 6),
          const ShimmerBox(width: 60, height: 10, radius: 6),
        ],
      ),
    );
  }
}

class ShimmerList extends StatelessWidget {
  final int count;
  const ShimmerList({super.key, this.count = 5});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (_, __) => const ShimmerCard(),
    );
  }
}
