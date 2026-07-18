import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart' show dioClientProvider;
import '../../data/datasources/search_remote_datasource.dart';
import '../../data/repositories/search_repository_impl.dart';
import '../../domain/repositories/search_repository.dart';
import '../../domain/usecases/search_menu_items.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>((ref) {
  return SearchRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final searchRepositoryProvider = Provider<SearchRepository>((ref) {
  return SearchRepositoryImpl(ref.read(searchRemoteDataSourceProvider));
});

final searchMenuItemsProvider = Provider<SearchMenuItems>((ref) {
  return SearchMenuItems(ref.read(searchRepositoryProvider));
});

/// Holds the current search box text. SearchPage updates this on
/// submit; searchResultsProvider watches it and re-fetches whenever
/// it changes.
final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider = FutureProvider<List<MenuItemEntity>>((ref) async {
  final query = ref.watch(searchQueryProvider);
  if (query.trim().isEmpty) return [];

  final result = await ref.read(searchMenuItemsProvider)(query.trim());
  return result.fold((failure) => throw failure.message, (items) => items);
});
