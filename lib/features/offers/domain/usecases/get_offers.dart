import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/offer_entity.dart';
import '../repositories/offer_repository.dart';

class GetOffers implements UseCase<List<OfferEntity>, NoParams> {
  final OfferRepository repository;
  const GetOffers(this.repository);

  @override
  Future<Either<Failure, List<OfferEntity>>> call(NoParams params) {
    return repository.getOffers();
  }
}
