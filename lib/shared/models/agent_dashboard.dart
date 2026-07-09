class AgentDashboard {
  final int todayCollections;
  final int todayFarmers;
  final int pendingUploads;
  final int offlineRecords;
  final double todayWeight;
  final double weeklyWeight;
  final double monthlyRevenue;
  final int activePickups;
  final List<WeeklyEntry> weeklyBreakdown;

  const AgentDashboard({
    required this.todayCollections,
    required this.todayFarmers,
    required this.pendingUploads,
    required this.offlineRecords,
    required this.todayWeight,
    required this.weeklyWeight,
    required this.monthlyRevenue,
    required this.activePickups,
    required this.weeklyBreakdown,
  });

  factory AgentDashboard.fromJson(Map<String, dynamic> json) => AgentDashboard(
        todayCollections: (json['todayCollections'] as num?)?.toInt() ?? 0,
        todayFarmers: (json['todayFarmers'] as num?)?.toInt() ?? 0,
        pendingUploads: (json['pendingUploads'] as num?)?.toInt() ?? 0,
        offlineRecords: (json['offlineRecords'] as num?)?.toInt() ?? 0,
        todayWeight: (json['todayWeight'] as num?)?.toDouble() ?? 0.0,
        weeklyWeight: (json['weeklyWeight'] as num?)?.toDouble() ?? 0.0,
        monthlyRevenue: (json['monthlyRevenue'] as num?)?.toDouble() ?? 0.0,
        activePickups: (json['activePickups'] as num?)?.toInt() ?? 0,
        weeklyBreakdown: (json['weeklyBreakdown'] as List<dynamic>?)
                ?.map((e) => WeeklyEntry.fromJson(e as Map<String, dynamic>))
                .toList() ??
            _emptyWeek(),
      );

  static List<WeeklyEntry> _emptyWeek() => const [
        WeeklyEntry(day: 'Mon', kg: 0),
        WeeklyEntry(day: 'Tue', kg: 0),
        WeeklyEntry(day: 'Wed', kg: 0),
        WeeklyEntry(day: 'Thu', kg: 0),
        WeeklyEntry(day: 'Fri', kg: 0),
        WeeklyEntry(day: 'Sat', kg: 0),
        WeeklyEntry(day: 'Sun', kg: 0),
      ];
}

class WeeklyEntry {
  final String day;
  final double kg;

  const WeeklyEntry({required this.day, required this.kg});

  factory WeeklyEntry.fromJson(Map<String, dynamic> json) => WeeklyEntry(
        day: json['day'] as String? ?? '',
        kg: (json['kg'] as num?)?.toDouble() ?? 0.0,
      );
}
