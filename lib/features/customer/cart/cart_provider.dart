import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/product.dart';

class CartItem {
  final Product product;
  final int quantity;
  const CartItem({required this.product, required this.quantity});

  CartItem copyWith({int? quantity}) =>
      CartItem(product: product, quantity: quantity ?? this.quantity);

  double get subtotal => product.pricePerUnit * quantity;
}

class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void add(Product product) {
    final idx = state.indexWhere((c) => c.product.id == product.id);
    if (idx >= 0) {
      final updated = List<CartItem>.from(state);
      updated[idx] = updated[idx].copyWith(quantity: updated[idx].quantity + 1);
      state = updated;
    } else {
      state = [...state, CartItem(product: product, quantity: 1)];
    }
  }

  void increment(String productId) {
    state = [
      for (final c in state)
        if (c.product.id == productId) c.copyWith(quantity: c.quantity + 1) else c,
    ];
  }

  void decrement(String productId) {
    state = [
      for (final c in state)
        if (c.product.id == productId && c.quantity > 1)
          c.copyWith(quantity: c.quantity - 1)
        else if (c.product.id != productId)
          c,
    ];
  }

  void remove(String productId) {
    state = state.where((c) => c.product.id != productId).toList();
  }

  void clear() => state = [];

  int get totalItems => state.fold(0, (s, c) => s + c.quantity);
  double get totalAmount => state.fold(0.0, (s, c) => s + c.subtotal);
}

final cartProvider =
    StateNotifierProvider<CartNotifier, List<CartItem>>((_) => CartNotifier());

final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider.notifier).totalItems;
});
