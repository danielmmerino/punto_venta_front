import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/inventory/bodegas/controllers/bodegas_controller.dart';
import 'package:punto_venta_front/features/inventory/bodegas/data/bodegas_repository.dart';

class MockBodegasRepository extends Mock implements BodegasRepository {}

void main() {
  group('BodegasController', () {
    test('maps 422 codigo already_taken to field error', () async {
      final repo = MockBodegasRepository();
      when(() => repo.create(any())).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: ''),
          response: Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 422,
            data: {
              'error': {
                'details': {
                  'codigo': ['already_taken']
                }
              }
            },
          ),
        ),
      );
      final container = ProviderContainer(overrides: [
        bodegasRepositoryProvider.overrideWithValue(repo),
      ]);
      final controller = container.read(bodegasControllerProvider.notifier);
      expect(
        () async => controller.create({'codigo': 'A', 'nombre': 'B'}),
        throwsA(isA<DioException>()),
      );
      final fieldErrors =
          container.read(bodegasControllerProvider).fieldErrors;
      expect(fieldErrors['codigo'], ['already_taken']);
    });
  });
}
