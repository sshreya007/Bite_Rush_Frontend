import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart' show dioClientProvider;
import '../../data/datasources/category_remote_datasource.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/get_category_items.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../../../core/usecase/usecase.dart';

final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>((ref) {
  return CategoryRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryImpl(ref.read(categoryRemoteDataSourceProvider));
});

final getCategoriesProvider = Provider<GetCategories>((ref) {
  return GetCategories(ref.read(categoryRepositoryProvider));
});

final getCategoryItemsProvider = Provider<GetCategoryItems>((ref) {
  return GetCategoryItems(ref.read(categoryRepositoryProvider));
});

/// Fetches the categories list once and caches it — FutureProvider
/// handles loading/error/data states automatically so pages can just
/// use a .when() on this instead of manual state management.
final categoriesListProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final result = await ref.read(getCategoriesProvider)(const NoParams());
  return result.fold((failure) => throw failure.message, (categories) => categories);
});

/// Family provider: each distinct categoryId gets its own cached
/// future, so navigating between different categories doesn't
/// re-fetch unnecessarily and each keeps separate loading state.
final categoryItemsProvider =
    FutureProvider.family<List<MenuItemEntity>, String>((ref, categoryId) async {
  final result = await ref.read(getCategoryItemsProvider)(categoryId);
  return result.fold((failure) => throw failure.message, (items) => items);
});
