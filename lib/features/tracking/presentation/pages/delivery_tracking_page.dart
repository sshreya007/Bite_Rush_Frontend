import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_scaffold.dart';

class DeliveryTrackingPage extends StatefulWidget {
  final String orderId;

  const DeliveryTrackingPage({super.key, required this.orderId});

  @override
  State<DeliveryTrackingPage> createState() => _DeliveryTrackingPageState();
}

class _DeliveryTrackingPageState extends State<DeliveryTrackingPage> {
  @override
  void initState() {
    super.initState();
    // Show the confirmation once the first frame is up — showing a
    // SnackBar during initState directly would fail since the
    // ScaffoldMessenger isn't attached to the tree yet at that point.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order placed successfully!'),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 3),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              ),
              const SizedBox(height: 4),
              const Text('Delivery tracking', style: TextStyle(fontSize: 12, color: AppColors.hintText)),
              const SizedBox(height: 4),
              const Text(
                'Delivery',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.labelText),
              ),
              const SizedBox(height: 40),
              Center(
                child: Container(
                  width: 220,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delivery_dining, size: 100, color: AppColors.logoBrown),
                ),
              ),
              const SizedBox(height: 32),
              const Center(
                child: Text(
                  'We deliver within 40 minutes',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.labelText),
                ),
              ),
              const SizedBox(height: 12),
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'If you don\'t get what you ordered within 40 minutes then the food will be free of cost',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: AppColors.hintText),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Company Policy',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primaryOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
