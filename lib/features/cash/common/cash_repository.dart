import 'package:dio/dio.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../core/network/dio_client.dart';

final cashRepositoryProvider = Provider<CashRepository>((ref) {
  final dio = ref.read(dioProvider);
  return CashRepository(dio);
});

class CashAlreadyClosedException implements Exception {}

class CashRepository {
  CashRepository(this._dio);
  final Dio _dio;
  final _uuid = const Uuid();

  Future<CashStatus> getStatus({required int localId, DateTime? fecha}) async {
    final query = {
      'local_id': localId,
      if (fecha != null) 'fecha': DateFormat('yyyy-MM-dd').format(fecha),
    };
    final resp = await _dio.get('/v1/caja/estado', queryParameters: query);
    return CashStatus.fromJson(Map<String, dynamic>.from(resp.data as Map));
  }

  Future<CloseCashResponse> closeCash({
    required int aperturaId,
    required List<MethodCount> conteos,
    String? observaciones,
  }) async {
    final key = 'CLOSE-$aperturaId-${_uuid.v4()}';
    try {
      final resp = await _dio.post('/v1/caja/cierre',
          data: {
            'apertura_id': aperturaId,
            'conteos':
                conteos.map((e) => {'metodo_id': e.metodoId, 'monto': e.conteo}).toList(),
            if (observaciones != null) 'observaciones': observaciones,
          },
          options: Options(headers: {'Idempotency-Key': key}));
      return CloseCashResponse.fromJson(
          Map<String, dynamic>.from(resp.data as Map));
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        throw CashAlreadyClosedException();
      }
      rethrow;
    }
  }
}

class CashStatus {
  CashStatus({
    required this.abierta,
    required this.aperturaId,
    required this.operador,
    required this.desde,
    required this.fondoInicial,
    required this.totalesPorMetodo,
  });

  final bool abierta;
  final int aperturaId;
  final Operator operador;
  final DateTime desde;
  final double fondoInicial;
  final List<MethodExpected> totalesPorMetodo;

  factory CashStatus.fromJson(Map<String, dynamic> json) {
    return CashStatus(
      abierta: json['abierta'] as bool,
      aperturaId: json['apertura_id'] as int,
      operador: Operator.fromJson(Map<String, dynamic>.from(json['operador'])),
      desde: DateTime.parse(json['desde'] as String),
      fondoInicial: (json['fondo_inicial'] as num).toDouble(),
      totalesPorMetodo: (json['totales_por_metodo'] as List<dynamic>? ?? [])
          .map((e) => MethodExpected.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class Operator {
  const Operator({required this.id, required this.nombre});
  final int id;
  final String nombre;

  factory Operator.fromJson(Map<String, dynamic> json) {
    return Operator(id: json['id'] as int, nombre: json['nombre'] as String);
  }
}

class MethodExpected {
  MethodExpected({
    required this.metodoId,
    required this.codigo,
    required this.nombre,
    required this.esperado,
  });

  final int metodoId;
  final String codigo;
  final String nombre;
  final double esperado;

  factory MethodExpected.fromJson(Map<String, dynamic> json) {
    return MethodExpected(
      metodoId: json['metodo_id'] as int,
      codigo: json['codigo'] as String,
      nombre: json['nombre'] as String,
      esperado: (json['esperado'] as num?)?.toDouble() ?? 0,
    );
  }
}

class CloseCashResponse {
  CloseCashResponse({required this.cierreId, this.diferencias = const [], this.pdfUrl});
  final int cierreId;
  final List<CloseDifference> diferencias;
  final String? pdfUrl;

  factory CloseCashResponse.fromJson(Map<String, dynamic> json) {
    return CloseCashResponse(
      cierreId: json['cierre_id'] as int,
      pdfUrl: json['pdf_url'] as String?,
      diferencias: (json['diferencias'] as List<dynamic>? ?? [])
          .map((e) => CloseDifference.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }
}

class CloseDifference {
  CloseDifference({required this.metodoId, required this.esperado, required this.contado, required this.diferencia});
  final int metodoId;
  final double esperado;
  final double contado;
  final double diferencia;

  factory CloseDifference.fromJson(Map<String, dynamic> json) {
    return CloseDifference(
      metodoId: json['metodo_id'] as int,
      esperado: (json['esperado'] as num).toDouble(),
      contado: (json['contado'] as num).toDouble(),
      diferencia: (json['diferencia'] as num).toDouble(),
    );
  }
}

class MethodCount {
  MethodCount({
    required this.metodoId,
    required this.codigo,
    required this.nombre,
    required this.esperado,
    this.conteo = 0,
  });
  final int metodoId;
  final String codigo;
  final String nombre;
  final double esperado;
  final double conteo;

  double get diferencia => conteo - esperado;

  MethodCount copyWith({double? conteo}) {
    return MethodCount(
      metodoId: metodoId,
      codigo: codigo,
      nombre: nombre,
      esperado: esperado,
      conteo: conteo ?? this.conteo,
    );
  }
}
