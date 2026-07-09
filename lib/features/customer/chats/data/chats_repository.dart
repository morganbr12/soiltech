import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/core/network/dio_provider.dart';

final chatsRepositoryProvider = Provider<ChatsRepository>((ref) {
  return ChatsRepository(ref.watch(dioProvider));
});

// ─── Models ───────────────────────────────────────────────────────────────────

class ChatThread {
  final String id;
  final String lbcId;
  final String lbcName;
  final String topic;
  final String region;
  final String lastMessage;
  final int unreadCount;
  final String status;

  ChatThread({
    required this.id,
    required this.lbcId,
    required this.lbcName,
    required this.topic,
    required this.region,
    required this.lastMessage,
    required this.unreadCount,
    required this.status,
  });

  factory ChatThread.fromJson(Map<String, dynamic> j) => ChatThread(
        id: j['id'] as String? ?? '',
        lbcId: j['lbcId'] as String? ?? '',
        lbcName: j['lbcName'] as String? ?? 'LBC',
        topic: j['topic'] as String? ?? 'Enquiry',
        region: j['region'] as String? ?? '',
        lastMessage: j['lastMessage'] as String? ?? '',
        unreadCount: (j['unreadCount'] as num?)?.toInt() ?? 0,
        status: j['status'] as String? ?? 'open',
      );

  bool get isOpen => status == 'open';
}

class ChatMsg {
  final String id;
  final String message;
  final String senderType; // customer | lbc | system
  final DateTime createdAt;

  ChatMsg({
    required this.id,
    required this.message,
    required this.senderType,
    required this.createdAt,
  });

  bool get isMe => senderType == 'customer';
  bool get isSystem => senderType == 'system';

  factory ChatMsg.fromJson(Map<String, dynamic> j) => ChatMsg(
        id: j['id'] as String? ?? '',
        message: j['message'] as String? ?? j['content'] as String? ?? '',
        senderType: j['senderType'] as String? ?? 'customer',
        createdAt: j['createdAt'] != null
            ? DateTime.tryParse(j['createdAt'].toString()) ?? DateTime.now()
            : DateTime.now(),
      );
}

// ─── Repository ───────────────────────────────────────────────────────────────

class ChatsRepository {
  final Dio _dio;
  ChatsRepository(this._dio);

  Future<List<ChatThread>> getChats() async {
    final res = await _dio.get('/chats');
    final list = res.data['data'] as List<dynamic>? ?? [];
    return list.map((e) => ChatThread.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ChatThread> startChat({
    required String produceListingId,
    String? message,
  }) async {
    final res = await _dio.post('/chats', data: {
      'produceListingId': produceListingId,
      if (message != null && message.isNotEmpty) 'message': message,
    });
    return ChatThread.fromJson(res.data['data'] as Map<String, dynamic>);
  }

  Future<List<ChatMsg>> getMessages(String chatId, {int page = 1, int limit = 50}) async {
    final res = await _dio.get(
      '/chats/$chatId/messages',
      queryParameters: {'page': page, 'limit': limit},
    );
    final list = res.data['data'] as List<dynamic>? ?? [];
    return list.map((e) => ChatMsg.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<ChatMsg> sendMessage(String chatId, String message) async {
    final res = await _dio.post('/chats/$chatId/messages', data: {'message': message});
    return ChatMsg.fromJson(res.data['data'] as Map<String, dynamic>);
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final chatListProvider = FutureProvider<List<ChatThread>>((ref) {
  return ref.read(chatsRepositoryProvider).getChats();
});

final chatMessagesProvider =
    FutureProvider.family<List<ChatMsg>, String>((ref, chatId) {
  return ref.read(chatsRepositoryProvider).getMessages(chatId);
});
