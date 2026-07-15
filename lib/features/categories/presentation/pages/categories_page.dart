import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../../../../core/widgets/filter_tabs_bar.dart';
import '../../../../core/widgets/app_bottom_nav_bar.dart';
import '../../../restaurant_details/presentation/pages/restaurants_list_page.dart';
import '../providers/category_provider.dart';
import 'category_items_page.dart';

class CategoriesPage extends ConsumerStatefulWidget {
  const CategoriesPage({super.key});

  @override
  ConsumerState<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends ConsumerState<CategoriesPage> {
  int _navIndex = -1;

  void _onNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }
    if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const RestaurantsListPage()));
      return;
    }
    // TODO: index == 2 -> Cart, index == 3 -> Profile, once built.
    setState(() => _navIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesListProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
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
              const CustomSearchBar(readOnly: true),
              const SizedBox(height: 20),
              const FilterTabsBar(selected: 'Categories'),
              const SizedBox(height: 20),
              Expanded(
                child: categoriesAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primaryOrange)),
                  error: (error, _) => Center(child: Text('Failed to load categories: $error')),
                  data: (categories) {
                    if (categories.isEmpty) {
                      return const Center(child: Text('No categories yet'));
                    }
                    return ListView.separated(
                      itemCount: categories.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
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
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.headerOrange.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    category.image,
                                    width: 60,
                                    height: 60,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 60,
                                      height: 60,
                                      color: Colors.grey.shade200,
                                      child: const Icon(Icons.fastfood, color: Colors.grey),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  category.name,
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
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
      bottomNavigationBar: AppBottomNavBar(currentIndex: _navIndex, onTap: _onNavTap),
    );
  }
}
