import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../entities/category_entity.dart';

abstract class CategoryRepository {
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, List<MenuItemEntity>>> getCategoryItems(String categoryId);
}
