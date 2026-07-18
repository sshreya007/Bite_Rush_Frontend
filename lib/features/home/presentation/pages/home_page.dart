import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/filter_tabs_bar.dart';
import '../../../categories/presentation/providers/category_provider.dart';
import '../../../categories/presentation/pages/category_items_page.dart';
import '../../../categories/presentation/pages/categories_page.dart';
import '../../../restaurant_details/presentation/providers/restaurant_provider.dart';
import '../../../restaurant_details/presentation/pages/restaurants_list_page.dart';
import '../../../restaurant_details/presentation/pages/restaurant_menu_page.dart';
import '../../../offers/presentation/providers/offer_provider.dart';
import '../../../offers/presentation/pages/offers_page.dart';
import '../../../search/presentation/pages/search_page.dart';
import '../widgets/section_header.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesListProvider);
    final restaurantsAsync = ref.watch(restaurantsListProvider);
    final offersAsync = ref.watch(offersListProvider);

    return AppScaffold(
      currentIndex: 0,
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
                readOnly: true,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
                },
              ),
              const SizedBox(height: 20),

              const FilterTabsBar(selected: 'All'),
              const SizedBox(height: 28),

              // --- Offers section (real data) ---
              SectionHeader(
                title: 'Offers',
                onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const OffersPage())),
              ),
              const SizedBox(height: 12),
              offersAsync.when(
                loading: () => const SizedBox(
                  height: 140,
                  child: Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                ),
                error: (error, _) => SizedBox(
                  height: 140,
                  child: Center(child: Text('Failed to load: $error', style: const TextStyle(fontSize: 12))),
                ),
                data: (offers) {
                  if (offers.isEmpty) {
                    return const SizedBox(height: 140, child: Center(child: Text('No offers right now')));
                  }
                  final featured = offers.first;
                  return GestureDetector(
                    onTap: () async {
                      // If the offer has a linked restaurant, go straight
                      // there. Otherwise (demo/fallback) just open the
                      // first restaurant's menu so the tap isn't a dead end.
                      if (featured.restaurantId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RestaurantMenuPage(
                              restaurantId: featured.restaurantId,
                              restaurantName: featured.restaurantName.isNotEmpty
                                  ? featured.restaurantName
                                  : 'Restaurant',
                            ),
                          ),
                        );
                        return;
                      }

                      final restaurants = await ref.read(restaurantsListProvider.future);
                      if (restaurants.isEmpty || !context.mounted) return;
                      final fallback = restaurants.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RestaurantMenuPage(
                            restaurantId: fallback.id,
                            restaurantName: fallback.name,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Image.network(
                          featured.image,
                          height: 140,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(height: 140, color: Colors.grey.shade300),
                        ),
                        Container(
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.black.withOpacity(0.55), Colors.transparent],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          bottom: 12,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  featured.title,
                                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (featured.discountPercent > 0)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryOrange,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'SAVE ${featured.discountPercent}%',
                                    style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ));
                },
              ),
              const SizedBox(height: 28),

              // --- Categories section (real data) ---
              SectionHeader(
                title: 'Categories',
                onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())),
              ),
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
              SectionHeader(
                title: 'Popular restaurants',
                onViewAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantsListPage())),
              ),
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
    );
  }
}
