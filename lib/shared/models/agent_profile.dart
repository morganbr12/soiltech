import 'package:freezed_annotation/freezed_annotation.dart';

part 'agent_profile.freezed.dart';
part 'agent_profile.g.dart';

@freezed
abstract class AgentProfile with _$AgentProfile {
  const factory AgentProfile({
    required String id,
    required String name,
    required String phone,
    required String email,
    required String agentCode,
    required String region,
    required String district,
    String? avatarUrl,
    required int totalFarmersRegistered,
    required double totalProduceCollected,
    required int totalCollections,
    required double performanceScore,
    required DateTime joinDate,
  }) = _AgentProfile;

  factory AgentProfile.fromJson(Map<String, dynamic> json) => _$AgentProfileFromJson(json);
}
