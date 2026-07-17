import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../providers/cart_provider.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';

class CartPage extends ConsumerWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);
    final total = cartItems.fold<double>(0, (sum, item) => sum + item.subtotal);

    return AppScaffold(
      currentIndex: 2,
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
              const Text('Cart', style: TextStyle(fontSize: 12, color: AppColors.hintText)),
              const SizedBox(height: 4),
              const Text(
                'My Cart',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.labelText),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: cartItems.isEmpty
                    ? const Center(
                        child: Text('Your cart is empty', style: TextStyle(color: AppColors.hintText)),
                      )
                    : ListView.separated(
                        itemCount: cartItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.headerOrange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${item.name} x${item.quantity}',
                                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Rs ${item.price.toStringAsFixed(0)}',
                                        style: const TextStyle(fontSize: 13, color: AppColors.hintText),
                                      ),
                                      if (item.addons.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          item.addons.join(', '),
                                          style: const TextStyle(fontSize: 11, color: AppColors.hintText),
                                        ),
                                      ],
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          _StepperButton(
                                            icon: Icons.remove,
                                            onTap: () => cartNotifier.updateQuantity(item.cartLineId, item.quantity - 1),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 12),
                                            child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                          _StepperButton(
                                            icon: Icons.add,
                                            onTap: () => cartNotifier.updateQuantity(item.cartLineId, item.quantity + 1),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    item.image,
                                    width: 64,
                                    height: 64,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 64,
                                      height: 64,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.fastfood, color: Colors.grey),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              if (cartItems.isNotEmpty) ...[
                const Divider(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                    Text(
                      'Rs ${total.toStringAsFixed(0)}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                CustomButton(
                  label: 'Proceed to checkout',
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const CheckoutPage()));
                  },
                ),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepperButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: 11,
        backgroundColor: AppColors.primaryOrange,
        child: Icon(icon, size: 13, color: Colors.white),
      ),
    );
  }
}
