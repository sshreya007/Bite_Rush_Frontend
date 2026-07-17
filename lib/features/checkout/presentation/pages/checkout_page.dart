import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../domain/usecases/place_order.dart';
import '../providers/order_provider.dart';
import '../../../tracking/presentation/pages/delivery_tracking_page.dart';

class CheckoutPage extends ConsumerStatefulWidget {
  const CheckoutPage({super.key});

  @override
  ConsumerState<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends ConsumerState<CheckoutPage> {
  final _addressController = TextEditingController();

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _placeOrder() async {
    final address = _addressController.text.trim();
    if (address.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a delivery address'), backgroundColor: AppColors.error),
      );
      return;
    }

    final cartItems = ref.read(cartProvider);
    final success = await ref.read(checkoutNotifierProvider.notifier).submit(
          PlaceOrderParams(items: cartItems, deliveryAddress: address),
        );

    if (!mounted) return;

    if (success) {
      final order = ref.read(checkoutNotifierProvider).placedOrder!;
      ref.read(cartProvider.notifier).clear();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DeliveryTrackingPage(orderId: order.id)),
      );
    } else {
      final error = ref.read(checkoutNotifierProvider).errorMessage ?? 'Could not place order';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: AppColors.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartItems = ref.watch(cartProvider);
    final total = cartItems.fold<double>(0, (sum, item) => sum + item.subtotal);
    final isLoading = ref.watch(checkoutNotifierProvider).isLoading;

    return AppScaffold(
      currentIndex: -1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              IconButton(
                icon: const CircleAvatar(
                  backgroundColor: Color(0xFFFFC93C),
                  child: Icon(Icons.arrow_back, color: Colors.white, size: 18),
                ),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(height: 4),
              const Text('Checkout', style: TextStyle(fontSize: 12, color: AppColors.hintText)),
              const SizedBox(height: 4),
              const Text(
                'Checkout',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.labelText),
              ),
              const SizedBox(height: 24),
              const Text('Delivery Address', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: AppColors.headerOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                    hintText: 'Enter your address',
                    hintStyle: TextStyle(fontSize: 13, color: AppColors.hintText),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    border: InputBorder.none,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.headerOrange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Order Summary', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    ...cartItems.map((item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          child: Text('${item.name} x${item.quantity}', style: const TextStyle(fontSize: 13)),
                        )),
                    const SizedBox(height: 8),
                    Text(
                      'Total: Rs ${total.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('Payment Method: Cash', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(label: 'Place Order', isLoading: isLoading, onPressed: _placeOrder),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
