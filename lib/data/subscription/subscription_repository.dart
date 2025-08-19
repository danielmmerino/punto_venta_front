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
        final data = resp.data is Map<String, dynamic> &&
                resp.data.containsKey('data')
            ? resp.data['data'] as Map<String, dynamic>
            : resp.data as Map<String, dynamic>;
        final vigente = data['vigente'];
        if (vigente is bool) {
          _active = vigente;
        } else if (vigente is num) {
          _active = vigente != 0;
        } else {
          _active = false;
        }
      } else if (resp.statusCode == 403) {
        _active = false;
      }
    } catch (_) {
      _active = false;
    }
  }
}
