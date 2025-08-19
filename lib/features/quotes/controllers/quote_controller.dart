import 'package:uuid/uuid.dart';

import '../data/models/quote.dart';

class QuoteController {
  QuoteController(this.quote, {Uuid? uuid}) : _uuid = uuid ?? const Uuid();

  final Quote quote;
  final Uuid _uuid;

  void agregarItem(QuoteItem item) {
    quote.items.add(item);
  }

  void enviar() {
    if (quote.items.isEmpty) {
      throw StateError('Debe tener al menos una línea');
    }
    quote.estado = QuoteStatus.sent;
  }

  void aceptar() {
    if (quote.estado != QuoteStatus.sent) {
      throw StateError('Solo cotizaciones enviadas pueden aceptarse');
    }
    quote.estado = QuoteStatus.accepted;
  }

  void rechazar() {
    if (quote.estado != QuoteStatus.sent) {
      throw StateError('Solo cotizaciones enviadas pueden rechazarse');
    }
    quote.estado = QuoteStatus.rejected;
  }

  String facturar() {
    if (quote.estado != QuoteStatus.accepted) {
      throw StateError('Solo cotizaciones aceptadas pueden facturarse');
    }
    // En una implementación real se llamaría al backend y se obtendría el ID de factura.
    return 'INV-${quote.clienteId}';
  }

  String idempotencyKey(String action, int id) {
    switch (action) {
      case 'SEND':
        return 'QTE-$id-SEND-${_uuid.v4()}';
      case 'ACC':
      case 'REJ':
      case 'FAC':
        return 'QTE-$id-$action';
      default:
        throw ArgumentError('Acción inválida');
    }
  }
}
