import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../checkout/presentation/providers/order_provider.dart';

class OrderHistoryPage extends ConsumerWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersAsync = ref.watch(orderHistoryProvider);

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
              const Text(
                'Order History',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.labelText),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ordersAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                  error: (error, _) => Center(child: Text('Failed to load orders: $error')),
                  data: (orders) {
                    if (orders.isEmpty) {
                      return const Center(child: Text('No orders yet', style: TextStyle(color: AppColors.hintText)));
                    }
                    return ListView.separated(
                      itemCount: orders.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        final itemsSummary = order.items.map((i) => '${i.name} x${i.quantity}').join(', ');
                        return Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: AppColors.headerOrange.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      itemsSummary.isEmpty ? 'Order' : itemsSummary,
                                      style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryOrange,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      order.status,
                                      style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Rs ${order.totalAmount.toStringAsFixed(0)}',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                              ),
                              if (order.createdAt != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  '${order.createdAt!.day}/${order.createdAt!.month}/${order.createdAt!.year}',
                                  style: const TextStyle(fontSize: 11, color: AppColors.hintText),
                                ),
                              ],
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
