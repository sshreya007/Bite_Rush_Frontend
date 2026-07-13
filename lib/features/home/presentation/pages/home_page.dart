import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../../categories/presentation/pages/category_items_page.dart';
import '../../../restaurant_details/presentation/providers/restaurant_provider.dart';
import '../../../restaurant_details/presentation/pages/restaurants_list_page.dart';
import '../../../restaurant_details/presentation/pages/restaurant_menu_page.dart';
import '../widgets/home_filter_tabs.dart';
import '../widgets/section_header.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _selectedFilter = 'All';
  int _navIndex = 0;

  void _onNavTap(int index) {
    setState(() => _navIndex = index);
    if (index == 1) {
      // "Menu" tab -> Restaurants list, as requested.
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantsListPage()))
          .then((_) => setState(() => _navIndex = 0));
    }
    // TODO: index == 2 -> Cart, index == 3 -> Profile, once built.
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesListProvider);
    final restaurantsAsync = ref.watch(restaurantsListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
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

              // --- Offers section (still placeholder — no Offer model yet) ---
              SectionHeader(title: 'Offers', onViewAll: () {}),
              const SizedBox(height: 12),
              _PlaceholderBlock(height: 140),
              const SizedBox(height: 28),

              // --- Categories section (real data) ---
              SectionHeader(title: 'Categories', onViewAll: () {}),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: categoriesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                  error: (error, _) => Center(child: Text('Failed to load: $error', style: const TextStyle(fontSize: 12))),
                  data: (categories) {
                    if (categories.isEmpty) return const Center(child: Text('No categories yet'));
                    return ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, index) {
                        final category = categories[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CategoryItemsPage(
                                  categoryId: category.id,
                                  categoryName: category.name,
                                ),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(35),
                                child: Image.network(
                                  category.image,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    width: 70,
                                    height: 70,
                                    decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                                    child: const Icon(Icons.fastfood, color: Colors.grey),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(category.name, style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 28),

              // --- Popular restaurants section (real data) ---
              SectionHeader(title: 'Popular restaurants', onViewAll: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantsListPage()));
              }),
              const SizedBox(height: 12),
              restaurantsAsync.when(
                loading: () => const SizedBox(
                  height: 130,
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                ),
                error: (error, _) => SizedBox(
                  height: 130,
                  child: Center(child: Text('Failed to load: $error', style: const TextStyle(fontSize: 12))),
                ),
                data: (restaurants) {
                  if (restaurants.isEmpty) {
                    return const SizedBox(height: 130, child: Center(child: Text('No restaurants yet')));
                  }
                  final featured = restaurants.first;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RestaurantMenuPage(
                            restaurantId: featured.id,
                            restaurantName: featured.name,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Stack(
                        children: [
                          Image.network(
                            featured.banner.isNotEmpty ? featured.banner : featured.image,
                            height: 130,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(height: 130, color: Colors.grey.shade300),
                          ),
                          Container(
                            height: 130,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.black.withOpacity(0.5), Colors.transparent],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 16,
                            bottom: 12,
                            child: Text(
                              featured.name,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
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
