import 'package:flutter/material.dart';
import '../../shared/models/app_models.dart';
import '../../shared/models/produce_entry.dart';
import '../../app/core/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final bool showDot;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    this.textColor = Colors.white,
    this.showDot = true,
  });

  factory StatusBadge.fromSyncStatus(SyncStatus status) {
    return switch (status) {
      SyncStatus.synced => const StatusBadge(
          label: 'Synced',
          color: AppColors.successLight,
          textColor: AppColors.success,
        ),
      SyncStatus.pending => const StatusBadge(
          label: 'Pending',
          color: AppColors.warningLight,
          textColor: Color(0xFF7A5A00),
        ),
      SyncStatus.failed => const StatusBadge(
          label: 'Failed',
          color: AppColors.errorLight,
          textColor: AppColors.error,
        ),
    };
  }

  factory StatusBadge.fromCollectionStatus(CollectionStatus status) {
    return switch (status) {
      CollectionStatus.draft => const StatusBadge(
          label: 'Draft',
          color: Color(0xFFEEEEEE),
          textColor: Color(0xFF666666),
        ),
      CollectionStatus.submitted => const StatusBadge(
          label: 'Submitted',
          color: AppColors.infoLight,
          textColor: AppColors.info,
        ),
      CollectionStatus.approved => const StatusBadge(
          label: 'Approved',
          color: AppColors.successLight,
          textColor: AppColors.success,
        ),
      CollectionStatus.rejected => const StatusBadge(
          label: 'Rejected',
          color: AppColors.errorLight,
          textColor: AppColors.error,
        ),
    };
  }

  factory StatusBadge.fromPaymentStatus(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.pending => const StatusBadge(
          label: 'Pending',
          color: AppColors.warningLight,
          textColor: Color(0xFF7A5A00),
        ),
      PaymentStatus.processing => const StatusBadge(
          label: 'Processing',
          color: AppColors.infoLight,
          textColor: AppColors.info,
        ),
      PaymentStatus.paid => const StatusBadge(
          label: 'Paid',
          color: AppColors.successLight,
          textColor: AppColors.success,
        ),
      PaymentStatus.failed => const StatusBadge(
          label: 'Failed',
          color: AppColors.errorLight,
          textColor: AppColors.error,
        ),
    };
  }

  factory StatusBadge.fromLogisticsStatus(LogisticsStatus status) {
    return switch (status) {
      LogisticsStatus.pending => const StatusBadge(
          label: 'Pending',
          color: AppColors.warningLight,
          textColor: Color(0xFF7A5A00),
        ),
      LogisticsStatus.assigned => const StatusBadge(
          label: 'Assigned',
          color: AppColors.infoLight,
          textColor: AppColors.info,
        ),
      LogisticsStatus.inTransit => const StatusBadge(
          label: 'In Transit',
          color: Color(0xFFE8F4FD),
          textColor: Color(0xFF0277BD),
        ),
      LogisticsStatus.delivered => const StatusBadge(
          label: 'Delivered',
          color: AppColors.successLight,
          textColor: AppColors.success,
        ),
    };
  }

  factory StatusBadge.fromProduceStatus(ProduceStatus status) {
    return switch (status) {
      ProduceStatus.pending => const StatusBadge(
          label: 'Pending',
          color: Color(0xFFFFF3E0),
          textColor: Color(0xFFE65100),
        ),
      ProduceStatus.approved => const StatusBadge(
          label: 'Approved',
          color: AppColors.successLight,
          textColor: AppColors.success,
        ),
      ProduceStatus.rejected => const StatusBadge(
          label: 'Rejected',
          color: AppColors.errorLight,
          textColor: AppColors.error,
        ),
    };
  }

  factory StatusBadge.fromFarmerStatus(FarmerStatus status) {
    return switch (status) {
      FarmerStatus.approved => const StatusBadge(
          label: 'Approved',
          color: AppColors.successLight,
          textColor: AppColors.success,
        ),
      FarmerStatus.pending => const StatusBadge(
          label: 'Pending',
          color: Color(0xFFFFF3E0),
          textColor: Color(0xFFE65100),
        ),
      FarmerStatus.rejected => const StatusBadge(
          label: 'Rejected',
          color: AppColors.errorLight,
          textColor: AppColors.error,
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: textColor,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

class GradeChip extends StatelessWidget {
  final String grade;

  const GradeChip({super.key, required this.grade});

  Color get _color => switch (grade) {
        'Grade A' => AppColors.success,
        'Grade B' => AppColors.info,
        'Grade C' => AppColors.warning,
        _ => AppColors.error,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _color.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        grade,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: _color,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
