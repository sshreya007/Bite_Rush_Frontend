import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart' show dioClientProvider;
import '../../data/datasources/offer_remote_datasource.dart';
import '../../data/repositories/offer_repository_impl.dart';
import '../../domain/entities/offer_entity.dart';
import '../../domain/repositories/offer_repository.dart';
import '../../domain/usecases/get_offers.dart';
import '../../../../core/usecase/usecase.dart';

final offerRemoteDataSourceProvider = Provider<OfferRemoteDataSource>((ref) {
  return OfferRemoteDataSourceImpl(ref.read(dioClientProvider));
});

final offerRepositoryProvider = Provider<OfferRepository>((ref) {
  return OfferRepositoryImpl(ref.read(offerRemoteDataSourceProvider));
});

final getOffersProvider = Provider<GetOffers>((ref) {
  return GetOffers(ref.read(offerRepositoryProvider));
});

final offersListProvider = FutureProvider<List<OfferEntity>>((ref) async {
  final result = await ref.read(getOffersProvider)(const NoParams());
  return result.fold((failure) => throw failure.message, (offers) => offers);
});
