import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../env/env.dart';
import '../../data/auth/auth_repository.dart';
import '../../data/subscription/subscription_repository.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(baseUrl: Env.baseUrl));
  final authRepo = ref.read(authRepositoryProvider);
  final subRepo = ref.read(subscriptionRepositoryProvider);

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) async {
      final token = await authRepo.getToken();
      if (token != null) {
        options.headers['Authorization'] = 'Bearer $token';
      }
      handler.next(options);
    },
    onError: (error, handler) async {
      if (error.response?.statusCode == 401 &&
          error.requestOptions.extra['retried'] != true) {
        try {
          await authRepo.refresh();
          error.requestOptions.extra['retried'] = true;
          final response = await dio.fetch(error.requestOptions);
          return handler.resolve(response);
        } catch (_) {
          await authRepo.logout();
        }
      }
      if (error.response?.statusCode == 403) {
        await subRepo.refresh();
      }
      handler.next(error);
    },
  ));
  return dio;
});
