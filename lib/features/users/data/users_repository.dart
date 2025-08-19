import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/network/dio_client.dart';
import 'models/user.dart';

final usersRepositoryProvider = Provider<UsersRepository>((ref) {
  final dio = ref.read(dioProvider);
  return UsersRepository(dio);
});

class UsersRepository {
  UsersRepository(this._dio);

  final Dio _dio;

  Future<List<User>> fetchUsers({Map<String, dynamic>? params}) async {
    final resp = await _dio.get('/v1/usuarios', queryParameters: params);
    final data = resp.data;
    if (data is List) {
      return data
          .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    }
    final list = data['data'] as List<dynamic>;
    return list
        .map((e) => User.fromJson(Map<String, dynamic>.from(e)))
        .toList();
  }

  Future<User> createUser(Map<String, dynamic> dto) async {
    final resp = await _dio.post('/v1/usuarios', data: dto);
    return User.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<User> updateUser(int id, Map<String, dynamic> dto) async {
    final resp = await _dio.put('/v1/usuarios/$id', data: dto);
    return User.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<void> deleteUser(int id) async {
    await _dio.delete('/v1/usuarios/$id');
  }

  Future<User> assignRoles(int id, List<String> roles) async {
    final resp = await _dio.post('/v1/usuarios/$id/roles', data: {'roles': roles});
    return User.fromJson(Map<String, dynamic>.from(resp.data));
  }
}
