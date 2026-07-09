class AgentActivity {
  final String action;
  final String detail;
  final DateTime timestamp;
  final String type;

  const AgentActivity({
    required this.action,
    required this.detail,
    required this.timestamp,
    required this.type,
  });

  factory AgentActivity.fromJson(Map<String, dynamic> json) => AgentActivity(
        action: json['action'] as String? ?? '',
        detail: json['detail'] as String? ?? '',
        timestamp: DateTime.tryParse(json['timestamp'] as String? ?? '') ?? DateTime.now(),
        type: json['type'] as String? ?? 'collection',
      );
}
