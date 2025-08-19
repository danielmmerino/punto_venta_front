import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/products/controllers/products_controller.dart';
import 'package:punto_venta_front/features/products/data/models/product.dart';
import 'package:punto_venta_front/features/products/data/products_repository.dart';

class MockProductsRepository extends Mock implements ProductsRepository {}

void main() {
  group('ProductsController', () {
    test('maps 422 codigo already_taken to field error', () async {
      final repo = MockProductsRepository();
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
        productsRepositoryProvider.overrideWithValue(repo),
      ]);
      final controller = container.read(productsControllerProvider.notifier);
      expect(
        () async => controller.create({'codigo': 'A'}),
        throwsA(isA<DioException>()),
      );
      final fieldErrors =
          container.read(productsControllerProvider).fieldErrors;
      expect(fieldErrors['codigo'], ['already_taken']);
    });

    test('toggleActive updates state', () async {
      final repo = MockProductsRepository();
      final product = Product(
        id: 1,
        codigo: 'A',
        nombre: 'Test',
        descripcion: null,
        categoriaId: 1,
        categoriaNombre: null,
        unidadId: 1,
        unidadCodigo: null,
        impuestoId: 1,
        impuestoCodigo: null,
        precio: 1.0,
        activo: false,
      );
      when(() => repo.list(params: any(named: 'params')))
          .thenAnswer((_) async => [product]);
      when(() => repo.toggleActive(1, true))
          .thenAnswer((_) async => product.copyWith(activo: true));

      final container = ProviderContainer(overrides: [
        productsRepositoryProvider.overrideWithValue(repo),
      ]);

      final controller = container.read(productsControllerProvider.notifier);
      await controller.load();
      await controller.toggleActive(1, true);
      final item = container.read(productsControllerProvider).items.first;
      expect(item.activo, true);
    });
  });
}
