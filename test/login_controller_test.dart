import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:punto_venta_front/features/auth/controllers/login_controller.dart';
import 'package:punto_venta_front/data/auth/auth_repository.dart';
import 'package:punto_venta_front/data/subscription/subscription_repository.dart';
import 'package:punto_venta_front/core/routing/app_router.dart';

class MockAuthNotifier extends Mock implements AuthNotifier {}

class FakeGoRouter extends Mock implements GoRouter {}

class FakeSubscriptionRepository extends Mock
    implements SubscriptionRepository {}

void main() {
  test('emits error message on 401', () async {
    final authNotifier = MockAuthNotifier();
    when(() => authNotifier.login(any<String>(), any<String>())).thenThrow(
      DioException(requestOptions: RequestOptions(path: ''),
          response: Response(requestOptions: RequestOptions(path: ''), statusCode: 401)),
    );
    final subRepo = FakeSubscriptionRepository();
    final router = FakeGoRouter();

    final container = ProviderContainer(overrides: [
      authStateProvider.overrideWith((ref) => authNotifier),
      subscriptionRepositoryProvider.overrideWithValue(subRepo),
      routerProvider.overrideWithValue(router),
    ]);

    final controller = container.read(loginControllerProvider.notifier);
    await controller.submit('a@b.com', 'password');
    expect(container.read(loginControllerProvider).error,
        'Credenciales inválidas');
  });
}
