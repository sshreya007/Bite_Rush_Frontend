import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../repositories/search_repository.dart';

class SearchMenuItems implements UseCase<List<MenuItemEntity>, String> {
  final SearchRepository repository;
  const SearchMenuItems(this.repository);

  @override
  Future<Either<Failure, List<MenuItemEntity>>> call(String query) {
    return repository.search(query);
  }
}
