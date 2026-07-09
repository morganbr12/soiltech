import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/core/network/dio_provider.dart';
import '../../../app/core/utils/app_logger.dart';

final logisticsRepositoryProvider = Provider<LogisticsRepository>((ref) {
  return LogisticsRepository(ref.watch(dioProvider));
});

// ─── Lightweight model (API-aligned) ─────────────────────────────────────────

class AgentPickupRequest {
  final String id;
  final String farmerId;
  final String farmerName;
  final String produceRecordId;
  final String? cropType;
  final String? scheduledDate;
  final String? notes;
  final String status;
  final String? driverName;
  final String? driverPhone;
  final String? vehicleNumber;
  final String? pickupLocation;
  final String? deliveryLocation;
  final Map<String, dynamic> raw;

  AgentPickupRequest({
    required this.id,
    required this.farmerId,
    required this.farmerName,
    required this.produceRecordId,
    this.cropType,
    this.scheduledDate,
    this.notes,
    required this.status,
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    this.pickupLocation,
    this.deliveryLocation,
    required this.raw,
  });

  factory AgentPickupRequest.fromJson(Map<String, dynamic> j) {
    final driver = j['driver'] as Map<String, dynamic>?;
    final farmer = j['farmer'] as Map<String, dynamic>?;
    return AgentPickupRequest(
      id: j['id'] as String? ?? '',
      farmerId: j['farmerId'] as String? ?? farmer?['id'] as String? ?? '',
      farmerName: j['farmerName'] as String? ?? farmer?['fullName'] as String? ?? 'Unknown Farmer',
      produceRecordId: j['produceRecordId'] as String? ?? '',
      cropType: j['cropType'] as String?,
      scheduledDate: j['scheduledDate'] as String?,
      notes: j['notes'] as String?,
      status: j['status'] as String? ?? 'pending',
      driverName: driver?['name'] as String? ?? j['driverName'] as String?,
      driverPhone: driver?['phone'] as String? ?? j['driverPhone'] as String?,
      vehicleNumber: j['vehicleNumber'] as String? ?? driver?['vehicleNumber'] as String?,
      pickupLocation: j['pickupLocation'] as String?,
      deliveryLocation: j['deliveryLocation'] as String?,
      raw: j,
    );
  }

  bool get hasDriver => driverName != null && driverName!.isNotEmpty;
  bool get isPending => status == 'pending';
  bool get isAssigned => status == 'assigned' || status == 'dispatched';
  bool get isInTransit => status == 'in_transit' || status == 'inTransit';
  bool get isCompleted => status == 'completed' || status == 'delivered';
}

// ─── Repository ───────────────────────────────────────────────────────────────

class LogisticsRepository {
  final Dio _dio;
  LogisticsRepository(this._dio);

  Future<List<AgentPickupRequest>> getPickupRequests({String? status, String? farmerId}) async {
    final params = <String, dynamic>{};
    if (status != null && status.isNotEmpty) params['status'] = status;
    if (farmerId != null && farmerId.isNotEmpty) params['farmer_id'] = farmerId;

    final res = await _dio.get('/pickup-requests', queryParameters: params);
    appLogger.d('[PickupRequests] raw: ${res.data}');

    final list = res.data['data'] as List<dynamic>? ?? [];
    return list.map((e) => AgentPickupRequest.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<AgentPickupRequest> createPickupRequest({
    required String farmerId,
    required String produceRecordId,
    required String scheduledDate,
    String? notes,
  }) async {
    final res = await _dio.post('/pickup-requests', data: {
      'farmerId': farmerId,
      'produceRecordId': produceRecordId,
      'scheduledDate': scheduledDate,
      if (notes != null && notes.isNotEmpty) 'notes': notes,
    });
    return AgentPickupRequest.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<void> updatePickupStatus(String id, String status) async {
    await _dio.put('/pickup-requests/$id', data: {'status': status});
  }

  Future<void> fieldConfirmOrder(String orderId) async {
    await _dio.patch('/customers/orders/$orderId/field-confirm');
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final pickupRequestsProvider = FutureProvider<List<AgentPickupRequest>>((ref) {
  return ref.read(logisticsRepositoryProvider).getPickupRequests();
});
