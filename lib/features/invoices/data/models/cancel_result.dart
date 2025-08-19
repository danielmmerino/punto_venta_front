import 'invoice.dart';

/// Result of cancelling an invoice which generates a credit note.
class CancelInvoiceResult {
  const CancelInvoiceResult({
    required this.facturaId,
    required this.notaCreditoId,
    this.ncNumero,
    required this.estadoSri,
    this.mensajes = const [],
  });

  final int facturaId;
  final int notaCreditoId;
  final String? ncNumero;
  final String estadoSri;
  final List<SriMessage> mensajes;

  factory CancelInvoiceResult.fromJson(Map<String, dynamic> json) {
    return CancelInvoiceResult(
      facturaId: json['factura_id'] as int,
      notaCreditoId: json['nota_credito_id'] as int,
      ncNumero: json['nc_numero'] as String?,
      estadoSri: json['estado_sri'] as String,
      mensajes: (json['mensajes'] as List<dynamic>?)
              ?.map((e) => SriMessage.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }
}
