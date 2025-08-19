import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../data/models/vendor.dart';

class VendorDetail extends StatelessWidget {
  const VendorDetail({super.key, required this.vendor});

  final Vendor vendor;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return AlertDialog(
      title: Row(
        children: [
          Expanded(child: Text(vendor.razonSocial)),
          Chip(label: Text(vendor.activo ? 'Activo' : 'Inactivo')),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('RUC: ${vendor.ruc}'),
          SizedBox(height: spacing.xs),
          if (vendor.email != null) Text('Email: ${vendor.email}'),
          if (vendor.telefono != null)
            Text('Teléfono: ${vendor.telefono}'),
          if (vendor.direccion != null)
            Text('Dirección: ${vendor.direccion}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, 'delete'),
          child: const Text('Eliminar'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, 'edit'),
          child: const Text('Editar'),
        ),
      ],
    );
  }
}
