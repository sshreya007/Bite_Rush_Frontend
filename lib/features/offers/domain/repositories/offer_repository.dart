import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/offer_entity.dart';

abstract class OfferRepository {
  Future<Either<Failure, List<OfferEntity>>> getOffers();
}
