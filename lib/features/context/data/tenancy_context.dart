import 'local.dart';

class TenancyContext {
  const TenancyContext({
    required this.empresaId,
    required this.empresaNombre,
    required this.suscripcionEstado,
    required this.locales,
  });

  final int empresaId;
  final String empresaNombre;
  final String suscripcionEstado;
  final List<Local> locales;

  factory TenancyContext.fromJson(Map<String, dynamic> json) {
    final empresaId = json['empresa_id'] as int;
    final localesJson = json['locales'] as List<dynamic>? ?? [];
    final locales = localesJson
        .map((e) => Local.fromJson({
              ...e as Map<String, dynamic>,
              'empresa_id': empresaId,
            }))
        .toList();
    return TenancyContext(
      empresaId: empresaId,
      empresaNombre: json['empresa_nombre'] as String,
      suscripcionEstado: json['suscripcion_estado'] as String,
      locales: locales,
    );
  }
}
