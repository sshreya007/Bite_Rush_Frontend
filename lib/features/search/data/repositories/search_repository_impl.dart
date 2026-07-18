import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../menu/domain/entities/menu_item_entity.dart';
import '../../domain/repositories/search_repository.dart';
import '../datasources/search_remote_datasource.dart';

class SearchRepositoryImpl implements SearchRepository {
  final SearchRemoteDataSource remoteDataSource;
  const SearchRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<MenuItemEntity>>> search(String query) async {
    try {
      final results = await remoteDataSource.search(query);
      return Right(results);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
