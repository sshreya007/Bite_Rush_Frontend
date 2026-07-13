import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoryItems implements UseCase<List<MenuItemEntity>, String> {
  final CategoryRepository repository;
  const GetCategoryItems(this.repository);

  @override
  Future<Either<Failure, List<MenuItemEntity>>> call(String categoryId) {
    return repository.getCategoryItems(categoryId);
  }
}
