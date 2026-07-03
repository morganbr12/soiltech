import 'package:flutter/material.dart';

class RatingWidget extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final double starSize;
  final bool compact;

  const RatingWidget({
    super.key,
    required this.rating,
    this.reviewCount,
    this.starSize = 14,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.star_rounded, size: starSize, color: const Color(0xFFF4A261)),
          const SizedBox(width: 3),
          Text(
            rating.toStringAsFixed(1),
            style: TextStyle(
              fontSize: starSize - 1,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          if (reviewCount != null) ...[
            const SizedBox(width: 3),
            Text(
              '($reviewCount)',
              style: TextStyle(
                fontSize: starSize - 2,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ],
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(5, (i) {
          final filled = i < rating.floor();
          final half = !filled && i < rating;
          return Icon(
            filled
                ? Icons.star_rounded
                : half
                    ? Icons.star_half_rounded
                    : Icons.star_outline_rounded,
            size: starSize,
            color: const Color(0xFFF4A261),
          );
        }),
        if (reviewCount != null) ...[
          const SizedBox(width: 6),
          Text(
            '${rating.toStringAsFixed(1)} ($reviewCount)',
            style: TextStyle(
              fontSize: starSize - 1,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ],
    );
  }
}

class RatingBar extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const RatingBar({super.key, required this.rating, required this.reviewCount});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Map<int, int> distribution = {5: 65, 4: 20, 3: 9, 2: 4, 1: 2};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              children: [
                Text(
                  rating.toStringAsFixed(1),
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.w800, letterSpacing: -1),
                ),
                RatingWidget(rating: rating, starSize: 16),
                const SizedBox(height: 4),
                Text(
                  '$reviewCount reviews',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [5, 4, 3, 2, 1].map((star) {
                  final pct = (distribution[star] ?? 0) / 100;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Text('$star', style: const TextStyle(fontSize: 11)),
                        const SizedBox(width: 4),
                        const Icon(Icons.star_rounded, size: 11, color: Color(0xFFF4A261)),
                        const SizedBox(width: 6),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: pct,
                              minHeight: 6,
                              backgroundColor: theme.colorScheme.surfaceContainerHighest,
                              color: const Color(0xFFF4A261),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

