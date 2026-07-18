import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';

abstract class SearchRepository {
  Future<Either<Failure, List<MenuItemEntity>>> search(String query);
}
