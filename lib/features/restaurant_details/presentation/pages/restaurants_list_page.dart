import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/filter_tabs_bar.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../providers/restaurant_provider.dart';
import 'restaurant_menu_page.dart';

class RestaurantsListPage extends ConsumerWidget {
  const RestaurantsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final restaurantsAsync = ref.watch(restaurantsListProvider);

    return AppScaffold(
      currentIndex: 1,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const CustomSearchBar(readOnly: true),
              const SizedBox(height: 20),
              const FilterTabsBar(selected: 'Restaurants'),
              const SizedBox(height: 20),
              Expanded(
                child: restaurantsAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                  error: (error, _) => Center(child: Text('Failed to load restaurants: $error')),
                  data: (restaurants) {
                    if (restaurants.isEmpty) {
                      return const Center(child: Text('No restaurants yet'));
                    }
                    return ListView.separated(
                      itemCount: restaurants.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final restaurant = restaurants[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => RestaurantMenuPage(
                                  restaurantId: restaurant.id,
                                  restaurantName: restaurant.name,
                                ),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Stack(
                              children: [
                                Image.network(
                                  restaurant.image,
                                  height: 110,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Container(
                                    height: 110,
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                                Container(
                                  height: 110,
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
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        restaurant.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (restaurant.cuisine.isNotEmpty)
                                        Text(
                                          restaurant.cuisine,
                                          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
