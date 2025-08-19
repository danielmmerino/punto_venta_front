import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:punto_venta_front/features/proc/vendors/data/vendors_repository.dart';

class _DioMock extends Mock implements Dio {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
  });

  test('fetch forwards query params', () async {
    final dio = _DioMock();
    when(() => dio.get(any(), queryParameters: any(named: 'queryParameters')))
        .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              data: [],
            ));
    final repo = VendorsRepository(dio);
    await repo.fetch(params: {'search': 'a', 'activo': 1});
    verify(() => dio.get('/v1/proveedores',
        queryParameters: {'search': 'a', 'activo': 1})).called(1);
  });

  test('map422 returns field errors', () {
    final dio = _DioMock();
    final repo = VendorsRepository(dio);
    final err = DioException(
      requestOptions: RequestOptions(path: ''),
      response: Response(
        requestOptions: RequestOptions(path: ''),
        statusCode: 422,
        data: {
          'details': {
            'ruc': ['duplicado']
          }
        },
      ),
      type: DioExceptionType.badResponse,
    );
    final mapped = repo.map422(err);
    expect(mapped['ruc'], ['duplicado']);
  });
}
