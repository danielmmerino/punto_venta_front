import 'package:flutter/material.dart';

/// Represents an invoice detail returned by the API.
class Invoice {
  const Invoice({
    required this.id,
    required this.numero,
    required this.fechaEmision,
    required this.cliente,
    required this.estadoSri,
    this.claveAcceso,
    required this.totales,
    this.mensajesSri = const [],
  });

  final int id;
  final String? numero;
  final DateTime? fechaEmision;
  final InvoiceCustomer? cliente;
  final String estadoSri;
  final String? claveAcceso;
  final InvoiceTotals totales;
  final List<SriMessage> mensajesSri;

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['id'] as int,
      numero: json['numero'] as String?,
      fechaEmision: json['fecha_emision'] != null
          ? DateTime.tryParse(json['fecha_emision'] as String)
          : null,
      cliente: json['cliente'] != null
          ? InvoiceCustomer.fromJson(
              Map<String, dynamic>.from(json['cliente'] as Map))
          : null,
      estadoSri: json['estado_sri'] as String,
      claveAcceso: json['clave_acceso'] as String?,
      totales: InvoiceTotals.fromJson(
        Map<String, dynamic>.from(json['totales'] as Map),
      ),
      mensajesSri: (json['mensajes_sri'] as List<dynamic>?)
              ?.map((e) => SriMessage.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }

  Invoice copyWith({String? estadoSri, List<SriMessage>? mensajesSri}) {
    return Invoice(
      id: id,
      numero: numero,
      fechaEmision: fechaEmision,
      cliente: cliente,
      estadoSri: estadoSri ?? this.estadoSri,
      claveAcceso: claveAcceso,
      totales: totales,
      mensajesSri: mensajesSri ?? this.mensajesSri,
    );
  }
}

/// Customer info of the invoice.
class InvoiceCustomer {
  const InvoiceCustomer({
    required this.id,
    required this.identificacion,
    required this.nombre,
  });

  final int id;
  final String identificacion;
  final String nombre;

  factory InvoiceCustomer.fromJson(Map<String, dynamic> json) {
    return InvoiceCustomer(
      id: json['id'] as int,
      identificacion: json['identificacion'] as String,
      nombre: json['nombre'] as String,
    );
  }
}

/// Totals section of the invoice.
class InvoiceTotals {
  const InvoiceTotals({
    required this.subtotal,
    required this.descuento,
    required this.iva,
    required this.total,
  });

  final double subtotal;
  final double descuento;
  final double iva;
  final double total;

  factory InvoiceTotals.fromJson(Map<String, dynamic> json) {
    return InvoiceTotals(
      subtotal: (json['subtotal'] as num).toDouble(),
      descuento: (json['descuento'] as num).toDouble(),
      iva: (json['iva'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
    );
  }
}

/// Message from SRI detailing processing info or errors.
class SriMessage {
  const SriMessage({
    required this.tipo,
    required this.codigo,
    required this.detalle,
  });

  final String tipo;
  final String codigo;
  final String detalle;

  factory SriMessage.fromJson(Map<String, dynamic> json) {
    return SriMessage(
      tipo: json['tipo'] as String,
      codigo: json['codigo'] as String,
      detalle: json['detalle'] as String,
    );
  }
}
