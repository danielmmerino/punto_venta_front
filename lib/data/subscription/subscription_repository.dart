import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../auth/auth_repository.dart';

final subscriptionRepositoryProvider = Provider<SubscriptionRepository>((ref) {
  return SubscriptionRepository(ref); 
});

class SubscriptionRepository {
  SubscriptionRepository(this._ref);

  final Ref _ref;
  bool _active = true;

  bool get isActive => _active;

  Future<void> refresh() async {
    final dio = _ref.read(dioProvider);
    final authRepo = _ref.read(authRepositoryProvider);
    try {
      final localId = await authRepo.getLocalId();
      final resp = await dio.get('/v1/estado-suscripcion',
          queryParameters: localId != null ? {'local_id': localId} : null);
      if (resp.statusCode == 200) {
        _active = resp.data['estado'] == 'active';
      } else if (resp.statusCode == 403) {
        _active = false;
      }
    } catch (_) {
      _active = false;
    }
  }
}
