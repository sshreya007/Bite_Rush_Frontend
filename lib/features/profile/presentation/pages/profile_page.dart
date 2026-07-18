import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import 'edit_profile_page.dart';
import 'order_history_page.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  Future<void> _confirmLogout(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You\'ll need to log in again to place orders.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    if (!context.mounted) return;

    await ref.read(authRepositoryProvider).logout();
    ref.read(cartProvider.notifier).clear();
    ref.invalidate(currentUserProvider);

    if (!context.mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _comingSoon(BuildContext context, String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature coming soon')),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProvider);

    return AppScaffold(
      currentIndex: 3,
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
              const Text('Profile', style: TextStyle(fontSize: 12, color: AppColors.hintText)),
              const SizedBox(height: 20),
              Expanded(
                child: userAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                  error: (error, _) => Center(child: Text('Failed to load profile: $error')),
                  data: (user) {
                    return Column(
                      children: [
                        const CircleAvatar(
                          radius: 44,
                          backgroundColor: Color(0xFFFFC93C),
                          child: Icon(Icons.person, size: 48, color: Colors.white),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          user.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.labelText),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => EditProfilePage(user: user)),
                            );
                          },
                          child: const Text(
                            'Edit Profile',
                            style: TextStyle(fontSize: 13, color: AppColors.primaryOrange, fontWeight: FontWeight.w600),
                          ),
                        ),
                        const SizedBox(height: 28),
                        _ProfileMenuTile(
                          label: 'Saved Addresses',
                          onTap: () => _comingSoon(context, 'Saved Addresses'),
                        ),
                        _ProfileMenuTile(
                          label: 'Payment Methods',
                          onTap: () => _comingSoon(context, 'Payment Methods'),
                        ),
                        _ProfileMenuTile(
                          label: 'Settings',
                          onTap: () => _comingSoon(context, 'Settings'),
                        ),
                        _ProfileMenuTile(
                          label: 'Order History',
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage()));
                          },
                        ),
                        const Spacer(),
                        CustomButton(
                          label: 'Logout',
                          onPressed: () => _confirmLogout(context, ref),
                        ),
                        const SizedBox(height: 16),
                      ],
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

class _ProfileMenuTile extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ProfileMenuTile({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: AppColors.headerOrange.withOpacity(0.15),
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const Icon(Icons.chevron_right, color: AppColors.hintText),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
