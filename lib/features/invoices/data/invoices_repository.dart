import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/network/dio_client.dart';
import 'models/invoice.dart';
import 'models/cancel_result.dart';

final invoicesRepositoryProvider = Provider<InvoicesRepository>((ref) {
  final dio = ref.read(dioProvider);
  return InvoicesRepository(dio);
});

/// Repository that handles API calls for invoices supporting fallback paths.
class InvoicesRepository {
  InvoicesRepository(this._dio);

  final Dio _dio;
  final _uuid = const Uuid();

  Future<Response<dynamic>> _requestWithFallback(
    String method,
    String primary,
    String fallback, {
    Options? options,
    data,
  }) async {
    try {
      return await _dio.request(primary,
          data: data, options: options, method: method);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return await _dio.request(fallback,
            data: data, options: options, method: method);
      }
      rethrow;
    }
  }

  Future<Invoice> getInvoice(int id) async {
    final resp = await _requestWithFallback(
      'GET',
      '/v1/facturas/$id',
      '/v1/ventas/facturas/$id',
    );
    return Invoice.fromJson(Map<String, dynamic>.from(resp.data));
  }

  Future<String> emit(int id) async {
    final key = 'EMIT-$id-${DateTime.now().microsecondsSinceEpoch}';
    final options = Options(headers: {'Idempotency-Key': key});
    final resp = await _requestWithFallback(
      'POST',
      '/v1/facturas/$id/emitir',
      '/v1/ventas/facturas/$id/emitir',
      options: options,
    );
    return (resp.data as Map<String, dynamic>)['estado_sri'] as String;
  }

  Future<CancelInvoiceResult> cancel(int id, String motivo) async {
    final key = 'NC-$id-${_uuid.v4()}';
    final options = Options(headers: {'Idempotency-Key': key});
    final resp = await _requestWithFallback(
      'POST',
      '/v1/facturas/$id/anular',
      '/v1/ventas/facturas/$id/anular',
      data: {'motivo': motivo},
      options: options,
    );
    return CancelInvoiceResult.fromJson(
        Map<String, dynamic>.from(resp.data as Map));
  }

  Future<Response<dynamic>> downloadPdf(int id) async {
    return _requestWithFallback(
      'GET',
      '/v1/facturas/$id/pdf',
      '/v1/ventas/facturas/$id/pdf',
      options: Options(responseType: ResponseType.bytes),
    );
  }

  Future<Response<dynamic>> downloadXml(int id) async {
    return _requestWithFallback(
      'GET',
      '/v1/facturas/$id/xml',
      '/v1/ventas/facturas/$id/xml',
      options: Options(responseType: ResponseType.bytes),
    );
  }
}
