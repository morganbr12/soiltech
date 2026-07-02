import 'package:intl/intl.dart';

extension DoubleFormatting on double {
  String get formatted => NumberFormat('#,##0.##').format(this);
  String get formattedWithUnit => '${NumberFormat('#,##0.##').format(this)} kg';
  String get currency => 'GHS ${NumberFormat('#,##0.00').format(this)}';
  String get acres => '${NumberFormat('#,##0.##').format(this)} acres';
  String get percent => '${NumberFormat('#,##0.#').format(this)}%';
}

extension IntFormatting on int {
  String get formatted => NumberFormat('#,##0').format(this);
}

extension DateTimeFormatting on DateTime {
  String get displayDate => DateFormat('dd MMM yyyy').format(this);
  String get displayTime => DateFormat('hh:mm a').format(this);
  String get displayDateTime => DateFormat('dd MMM yyyy • hh:mm a').format(this);
  String get shortDate => DateFormat('dd MMM').format(this);
  String get monthYear => DateFormat('MMM yyyy').format(this);
  String get dayOfWeek => DateFormat('EEEE').format(this);

  String get timeAgo {
    final now = DateTime.now();
    final diff = now.difference(this);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return displayDate;
  }
}

extension StringExtensions on String {
  String get initials {
    final parts = trim().split(' ');
    if (parts.isEmpty) return '';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  String get titleCase {
    return split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }

  bool get isValidPhone => RegExp(r'^\+?[0-9]{10,14}$').hasMatch(replaceAll(' ', ''));
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
}
