import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../widgets/home_filter_tabs.dart';
import '../widgets/section_header.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedFilter = 'All';
  int _navIndex = 0;

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    // TODO: navigate to the matching screen once built, e.g.:
    // if (index == 1) Navigator.pushNamed(context, '/orders');
    // if (index == 2) Navigator.pushNamed(context, '/cart');
    // if (index == 3) Navigator.pushNamed(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              // Top bar — swap for a real greeting/location once you
              // have user + address data wired in.
              const Text(
                'Home',
                style: TextStyle(fontSize: 12, color: AppColors.hintText),
              ),
              const SizedBox(height: 16),

              CustomSearchBar(
                onTap: () {
                  // TODO: Navigator.pushNamed(context, '/search');
                },
              ),
              const SizedBox(height: 20),

              HomeFilterTabs(
                selected: _selectedFilter,
                onChanged: (tab) => setState(() => _selectedFilter = tab),
              ),
              const SizedBox(height: 28),

              // --- Offers section (placeholder) ---
              SectionHeader(title: 'Offers', onViewAll: () {}),
              const SizedBox(height: 12),
              _PlaceholderBlock(height: 140),
              const SizedBox(height: 28),

              // --- Categories section (placeholder) ---
              SectionHeader(title: 'Categories', onViewAll: () {}),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 16),
                  itemBuilder: (_, __) => const _PlaceholderCircle(),
                ),
              ),
              const SizedBox(height: 28),

              // --- Popular restaurants section (placeholder) ---
              SectionHeader(title: 'Popular restaurants', onViewAll: () {}),
              const SizedBox(height: 12),
              _PlaceholderBlock(height: 130),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _navIndex,
        onTap: _onNavTap,
      ),
    );
  }
}

/// Temporary gray block standing in for Offers/Restaurants banners
/// until that data is wired up.
class _PlaceholderBlock extends StatelessWidget {
  final double height;
  const _PlaceholderBlock({required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

/// Temporary gray circle standing in for category images.
class _PlaceholderCircle extends StatelessWidget {
  const _PlaceholderCircle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(height: 8),
        Container(width: 40, height: 10, color: Colors.grey.shade200),
      ],
    );
  }
}
