import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import '../../../app/core/theme/app_colors.dart';
import '../../../app/core/utils/app_logger.dart';
import '../../../shared/models/delivery_fee_result.dart';
import '../../../shared/models/product.dart';
import '../../../shared/widgets/app_button.dart';
import '../data/products_repository.dart';
import '../orders/presentation/providers/orders_provider.dart';
import 'cart_provider.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final items = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtotal = notifier.totalAmount;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
          onPressed: () => context.pop(),
        ),
        title: Text(
          items.isEmpty ? 'My Basket' : 'My Basket (${notifier.totalItems})',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
        ),
        centerTitle: false,
        backgroundColor: isDark ? AppColors.backgroundDark : const Color(0xFFF5F7F5),
        elevation: 0,
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: () => notifier.clear(),
              child: const Text('Clear all', style: TextStyle(color: AppColors.error, fontSize: 13)),
            ),
        ],
      ),
      body: items.isEmpty
          ? _EmptyCart()
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    itemCount: items.length,
                    separatorBuilder: (context2, idx) => const SizedBox(height: 12),
                    itemBuilder: (_, i) => _CartItemCard(
                      item: items[i],
                      isDark: isDark,
                      onIncrement: () => notifier.increment(items[i].product.id),
                      onDecrement: () => notifier.decrement(items[i].product.id),
                      onRemove: () => notifier.remove(items[i].product.id),
                    ).animate(delay: Duration(milliseconds: 40 * i)).fadeIn(duration: 300.ms).slideY(begin: 0.05, end: 0),
                  ),
                ),
                _CartSummaryBar(
                  isDark: isDark,
                  subtotal: subtotal,
                  onCheckout: () => _openCheckout(context, items, subtotal),
                ),
              ],
            ),
    );
  }

  void _openCheckout(BuildContext context, List<CartItem> items, double subtotal) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CheckoutSheet(
        subtotal: subtotal,
        products: items.map((e) => e.product).toList(),
        onConfirm: (deliveryAddress, notes, fee, paymentType) =>
            _placeOrder(deliveryAddress, notes, items, paymentType),
      ),
    );
  }

  Future<bool> _placeOrder(
      String deliveryAddress, String notes, List<CartItem> items, String paymentType) async {
    if (items.isEmpty) return false;
    final first = items.first;
    final totalKg = items.fold<double>(0.0, (sum, e) => sum + e.quantity.toDouble());
    final ok = await ref.read(placeOrderProvider.notifier).placeOrder(
      produce: first.product.name,
      quantityKg: totalKg,
      pricePerKg: first.product.pricePerUnit,
      paymentType: paymentType,
      farmerId: first.product.farmerId,
      agentId: first.product.agentId,
    );
    if (ok) ref.read(cartProvider.notifier).clear();
    return ok;
  }
}

// ─── Cart summary bar ─────────────────────────────────────────────────────────

class _CartSummaryBar extends StatelessWidget {
  final bool isDark;
  final double subtotal;
  final VoidCallback onCheckout;

  const _CartSummaryBar(
      {required this.isDark, required this.subtotal, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 20, offset: const Offset(0, -4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
              Text('GHS ${subtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded, size: 13, color: AppColors.primaryLight),
              const SizedBox(width: 6),
              Text('Delivery fee calculated from your location',
                  style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 14),
          AppButton(label: 'Proceed to Checkout', onPressed: onCheckout),
        ],
      ),
    );
  }
}

// ─── Cart item card ───────────────────────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final CartItem item;
  final bool isDark;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onRemove;

  const _CartItemCard({
    required this.item,
    required this.isDark,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final p = item.product;
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: isDark ? 0.15 : 0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: p.imageUrl,
              width: 72, height: 72, fit: BoxFit.cover,
              errorWidget: (ctx, url, err) => Container(
                width: 72, height: 72,
                color: AppColors.primaryContainer,
                child: const Icon(Icons.agriculture_rounded, color: AppColors.primaryLight, size: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(p.name,
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: const Icon(Icons.close_rounded, size: 18, color: AppColors.error),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined, size: 11, color: AppColors.primaryLight),
                    const SizedBox(width: 3),
                    Flexible(
                      child: Text(p.location,
                          style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text('GHS ${item.subtotal.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
                    const Spacer(),
                    _QtyControl(quantity: item.quantity, onIncrement: onIncrement, onDecrement: onDecrement),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  const _QtyControl({required this.quantity, required this.onIncrement, required this.onDecrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _QtyBtn(icon: Icons.remove_rounded, onTap: onDecrement),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text('$quantity', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
        ),
        _QtyBtn(icon: Icons.add_rounded, onTap: onIncrement, filled: true),
      ],
    );
  }
}

class _QtyBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  const _QtyBtn({required this.icon, required this.onTap, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30, height: 30,
        decoration: BoxDecoration(
          color: filled ? AppColors.primary : AppColors.primaryContainer,
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 16, color: filled ? Colors.white : AppColors.primary),
      ),
    );
  }
}

// ─── Empty state ──────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.shopping_basket_outlined, size: 72,
              color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          const Text('Your basket is empty', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text('Add items from the home page',
              style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const SizedBox(height: 24),
          TextButton.icon(
            onPressed: () => context.pop(),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
            label: const Text('Browse products'),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

// ─── Checkout sheet ───────────────────────────────────────────────────────────

class _CheckoutSheet extends ConsumerStatefulWidget {
  final double subtotal;
  final List<Product> products;
  final Future<bool> Function(String deliveryAddress, String notes, DeliveryFeeResult? fee, String paymentType) onConfirm;

  const _CheckoutSheet({
    required this.subtotal,
    required this.products,
    required this.onConfirm,
  });

  @override
  ConsumerState<_CheckoutSheet> createState() => _CheckoutSheetState();
}

class _CheckoutSheetState extends ConsumerState<_CheckoutSheet> {
  final _addressCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  Position? _position;
  DeliveryFeeResult? _feeResult;
  String? _locationLabel;

  bool _locating = false;
  bool _calculatingFee = false;
  bool _placing = false;
  String? _locationError;
  String _paymentType = 'CASH';

  double get _total => widget.subtotal + (_feeResult?.feeGhs ?? 0);

  @override
  void dispose() {
    _addressCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    setState(() { _locating = true; _locationError = null; _feeResult = null; });

    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever || perm == LocationPermission.denied) {
        setState(() { _locationError = 'Location permission denied. Enable it in Settings.'; _locating = false; });
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );

      setState(() {
        _position = pos;
        _locationLabel = '${pos.latitude.toStringAsFixed(4)}, ${pos.longitude.toStringAsFixed(4)}';
        _locating = false;
      });

      await _fetchDeliveryFee(pos);
    } catch (e) {
      setState(() { _locationError = 'Could not get location: $e'; _locating = false; });
    }
  }

  Future<void> _fetchDeliveryFee(Position pos) async {
    if (widget.products.isEmpty) return;
    setState(() { _calculatingFee = true; _feeResult = null; });

    try {
      final repo = ref.read(productsRepositoryProvider);
      final fee = await repo.getDeliveryFee(
        productId: widget.products.first.id,
        deliveryLat: pos.latitude,
        deliveryLng: pos.longitude,
      );
      setState(() { _feeResult = fee; _calculatingFee = false; });
    } catch (e, st) {
      appLogger.e('[DeliveryFee] failed', error: e, stackTrace: st);
      setState(() { _calculatingFee = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    final canOrder = _feeResult != null && _addressCtrl.text.trim().isNotEmpty && !_placing;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Container(width: 36, height: 4, decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 20),
              const Text('Delivery Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text('We\'ll calculate the fee based on your delivery location',
                  style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurfaceVariant)),
              const SizedBox(height: 20),

              // ── Pickup (from product) ──────────────────────────────────────
              _InfoTile(
                icon: Icons.storefront_outlined,
                iconColor: AppColors.primary,
                title: 'Pickup from',
                value: widget.products.isNotEmpty
                    ? '${widget.products.first.farmerName} · ${widget.products.first.location}'
                    : 'Farm location',
              ),
              const SizedBox(height: 10),

              // Arrow
              Center(
                child: Container(
                  width: 32, height: 32,
                  decoration: const BoxDecoration(color: AppColors.primaryContainer, shape: BoxShape.circle),
                  child: const Icon(Icons.arrow_downward_rounded, size: 16, color: AppColors.primary),
                ),
              ),
              const SizedBox(height: 10),

              // ── Delivery location ─────────────────────────────────────────
              const Text('Delivery location', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),

              // Use current location button
              GestureDetector(
                onTap: _locating || _calculatingFee ? null : _useCurrentLocation,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: _position != null ? AppColors.primary : AppColors.primaryLight.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      _locating
                          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary))
                          : Icon(_position != null ? Icons.my_location_rounded : Icons.location_searching_rounded,
                              size: 20, color: AppColors.primary),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _locating ? 'Getting your location…' : 'Use my current location',
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary),
                            ),
                            if (_locationLabel != null)
                              Text(_locationLabel!, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      ),
                      if (_position != null)
                        const Icon(Icons.check_circle_rounded, size: 18, color: AppColors.success),
                    ],
                  ),
                ),
              ),

              if (_locationError != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.error_outline_rounded, size: 14, color: AppColors.error),
                    const SizedBox(width: 6),
                    Expanded(child: Text(_locationError!, style: const TextStyle(fontSize: 12, color: AppColors.error))),
                  ],
                ),
              ],

              const SizedBox(height: 12),

              // Human-readable address for the driver
              TextField(
                controller: _addressCtrl,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: 'Delivery address (for driver)',
                  hintText: 'e.g. 14 Liberation Road, Accra',
                  prefixIcon: const Icon(Icons.location_on_outlined, color: Color(0xFFE63946), size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 10),

              TextField(
                controller: _notesCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Notes (optional)',
                  prefixIcon: const Icon(Icons.notes_outlined, color: AppColors.primaryLight, size: 20),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.3))),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: AppColors.primary)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                ),
              ),
              const SizedBox(height: 14),

              // ── Payment type ───────────────────────────────────────────────
              const Text('Payment method', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Row(
                children: [
                  for (final type in [('CASH', Icons.payments_outlined), ('MOMO', Icons.phone_android_rounded)])
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _paymentType = type.$1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: EdgeInsets.only(right: type.$1 == 'CASH' ? 8 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _paymentType == type.$1
                                ? AppColors.primaryContainer.withValues(alpha: 0.7)
                                : (isDark ? const Color(0xFF1E2E20) : const Color(0xFFF0F6F1)),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: _paymentType == type.$1 ? AppColors.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(type.$2, size: 22, color: _paymentType == type.$1 ? AppColors.primary : theme.colorScheme.onSurfaceVariant),
                              const SizedBox(height: 4),
                              Text(type.$1, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: _paymentType == type.$1 ? AppColors.primary : theme.colorScheme.onSurfaceVariant)),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Fee breakdown (appears after GPS + API call) ───────────────
              AnimatedSize(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                child: _calculatingFee
                    ? Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary)),
                            const SizedBox(width: 12),
                            Text('Calculating delivery fee…',
                                style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurfaceVariant)),
                          ],
                        ),
                      )
                    : _feeResult != null
                        ? Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Distance / method badge
                                Row(
                                  children: [
                                    const Icon(Icons.route_rounded, size: 14, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Text(
                                      _feeResult!.distanceKm > 0
                                          ? '${_feeResult!.distanceKm.toStringAsFixed(1)} km from pickup'
                                          : 'Zone-based delivery fee',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                const Divider(height: 16),
                                _FeeRow(label: 'Subtotal', value: 'GHS ${widget.subtotal.toStringAsFixed(2)}'),
                                const SizedBox(height: 8),
                                _FeeRow(label: 'Delivery fee', value: 'GHS ${_feeResult!.baseFee.toStringAsFixed(2)}'),
                                if (_feeResult!.distanceFee > 0) ...[
                                  const SizedBox(height: 4),
                                  _FeeRow(
                                    label: 'Distance fee',
                                    value: 'GHS ${_feeResult!.distanceFee.toStringAsFixed(2)}',
                                    sub: '${_feeResult!.distanceKm.toStringAsFixed(1)} km × GHS ${_feeResult!.ratePerKm.toStringAsFixed(2)}/km',
                                  ),
                                ],
                                Divider(height: 20, color: AppColors.primary.withValues(alpha: 0.15)),
                                _FeeRow(label: 'Total', value: 'GHS ${_total.toStringAsFixed(2)}', bold: true),
                              ],
                            ),
                          ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.05, end: 0)
                        : const SizedBox.shrink(),
              ),

              AppButton(
                label: _placing
                    ? 'Placing order…'
                    : canOrder
                        ? 'Place Order — GHS ${_total.toStringAsFixed(2)}'
                        : _position == null
                            ? 'Use your location to continue'
                            : 'Enter delivery address',
                onPressed: canOrder ? _submit : null,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    setState(() => _placing = true);
    final ok = await widget.onConfirm(
      _addressCtrl.text.trim(),
      _notesCtrl.text.trim(),
      _feeResult,
      _paymentType,
    );
    if (!mounted) return;
    if (ok) {
      Navigator.of(context, rootNavigator: true).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(children: [
            Icon(Icons.check_circle_rounded, color: Colors.white, size: 18),
            SizedBox(width: 10),
            Text('Order placed successfully!'),
          ]),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        ),
      );
    } else {
      setState(() => _placing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to place order. Try again.'), backgroundColor: AppColors.error),
      );
    }
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  const _InfoTile({required this.icon, required this.iconColor, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? AppColors.cardDark : const Color(0xFFF5F7F5),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, fontWeight: FontWeight.w500)),
                Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeeRow extends StatelessWidget {
  final String label;
  final String value;
  final String? sub;
  final bool bold;
  const _FeeRow({required this.label, required this.value, this.sub, this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: bold ? 14 : 12, fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
                  color: bold ? null : Theme.of(context).colorScheme.onSurfaceVariant)),
              if (sub != null)
                Text(sub!, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
        Text(value, style: TextStyle(fontSize: bold ? 15 : 13, fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: bold ? AppColors.primary : null)),
      ],
    );
  }
}
