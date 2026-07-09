// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agent_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AgentProfile _$AgentProfileFromJson(Map<String, dynamic> json) =>
    _AgentProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      agentCode: json['agentCode'] as String,
      region: json['region'] as String,
      district: json['district'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      totalFarmersRegistered: (json['totalFarmersRegistered'] as num).toInt(),
      totalProduceCollected: (json['totalProduceCollected'] as num).toDouble(),
      totalCollections: (json['totalCollections'] as num).toInt(),
      performanceScore: (json['performanceScore'] as num).toDouble(),
      joinDate: DateTime.parse(json['joinDate'] as String),
    );

Map<String, dynamic> _$AgentProfileToJson(_AgentProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone': instance.phone,
      'email': instance.email,
      'agentCode': instance.agentCode,
      'region': instance.region,
      'district': instance.district,
      'avatarUrl': instance.avatarUrl,
      'totalFarmersRegistered': instance.totalFarmersRegistered,
      'totalProduceCollected': instance.totalProduceCollected,
      'totalCollections': instance.totalCollections,
      'performanceScore': instance.performanceScore,
      'joinDate': instance.joinDate.toIso8601String(),
    };
