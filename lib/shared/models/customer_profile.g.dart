// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'customer_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DeliveryAddress _$DeliveryAddressFromJson(Map<String, dynamic> json) =>
    _DeliveryAddress(
      id: json['id'] as String,
      label: json['label'] as String,
      fullAddress: json['fullAddress'] as String,
      city: json['city'] as String,
      region: json['region'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$DeliveryAddressToJson(_DeliveryAddress instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'fullAddress': instance.fullAddress,
      'city': instance.city,
      'region': instance.region,
      'isDefault': instance.isDefault,
      'lat': instance.lat,
      'lng': instance.lng,
    };

_CustomerProfile _$CustomerProfileFromJson(Map<String, dynamic> json) =>
    _CustomerProfile(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      accountType: $enumDecode(
        _$CustomerAccountTypeEnumMap,
        json['accountType'],
      ),
      profileImageUrl: json['profileImageUrl'] as String?,
      addresses:
          (json['addresses'] as List<dynamic>?)
              ?.map((e) => DeliveryAddress.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      totalOrders: (json['totalOrders'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$CustomerProfileToJson(_CustomerProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'email': instance.email,
      'accountType': _$CustomerAccountTypeEnumMap[instance.accountType]!,
      'profileImageUrl': instance.profileImageUrl,
      'addresses': instance.addresses,
      'totalOrders': instance.totalOrders,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$CustomerAccountTypeEnumMap = {
  CustomerAccountType.individual: 'individual',
  CustomerAccountType.restaurant: 'restaurant',
  CustomerAccountType.retailShop: 'retailShop',
  CustomerAccountType.marketTrader: 'marketTrader',
  CustomerAccountType.processor: 'processor',
  CustomerAccountType.exporter: 'exporter',
};
