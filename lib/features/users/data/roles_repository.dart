import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'models/role.dart';

final rolesRepositoryProvider = Provider<RolesRepository>((ref) {
  final dio = ref.read(dioProvider);
  return RolesRepository(dio);
});

class RolesRepository {
  RolesRepository(this._dio);

  final Dio _dio;

  Future<List<Role>> fetchRoles() async {
    final resp = await _dio.get('/v1/roles');
    final data = resp.data as List<dynamic>;
    return data
        .map((e) => Role.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<List<String>> fetchPermisos() async {
    final resp = await _dio.get('/v1/permisos');
    final data = resp.data as List<dynamic>;
    return data.cast<String>();
  }
}
