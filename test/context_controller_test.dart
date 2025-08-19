import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:punto_venta_front/features/context/controllers/context_controller.dart';
import 'package:punto_venta_front/features/context/data/context_repository.dart';
import 'package:punto_venta_front/features/context/data/local.dart';
import 'package:punto_venta_front/features/context/data/subscription_status.dart';
import 'package:punto_venta_front/core/network/dio_client.dart';
import 'package:punto_venta_front/core/routing/app_router.dart';

class FakeContextRepository extends Mock implements ContextRepository {}

class FakeGoRouter extends Mock implements GoRouter {}

class TestAdapter implements HttpClientAdapter {
  RequestOptions? options;
  @override
  void close({bool force = false}) {}

  @override
  Future<ResponseBody> fetch(RequestOptions options, Stream<List<int>>? requestStream,
      Future? cancelFuture) async {
    this.options = options;
    return ResponseBody.fromString('', 200, headers: {});
  }
}

void main() {
  test('selectLocal sets X-Local-Id header', () async {
    SharedPreferences.setMockInitialValues({});
    final repo = FakeContextRepository();
    when(() => repo.checkSubscription(localId: any(named: 'localId')))
        .thenAnswer((_) async => const SubscriptionStatus(vigente: true));
    final router = FakeGoRouter();
    final container = ProviderContainer(overrides: [
      contextRepositoryProvider.overrideWithValue(repo),
      routerProvider.overrideWithValue(router),
    ]);
    final controller = container.read(contextControllerProvider.notifier);
    controller.state = controller.state.copyWith(
        locales: [const Local(id: 1, nombre: 'A', empresaId: 1)]);
    final dio = container.read(dioProvider);
    final adapter = TestAdapter();
    dio.httpClientAdapter = adapter;

    await controller.selectLocal(1);
    await dio.get('/demo');

    expect(adapter.options!.headers['X-Local-Id'], '1');
  });
}
