class VentaHora {
  const VentaHora({
    required this.hora,
    required this.tickets,
    required this.ventasTotales,
  });

  final String hora;
  final int tickets;
  final double ventasTotales;

  factory VentaHora.fromJson(Map<String, dynamic> json) => VentaHora(
        hora: json['hora'] as String,
        tickets: json['tickets'] as int,
        ventasTotales: (json['ventas_totales'] as num).toDouble(),
      );
}
