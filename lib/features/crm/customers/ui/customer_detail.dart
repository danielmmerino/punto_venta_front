import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../data/models/customer.dart';

class CustomerDetail extends StatelessWidget {
  const CustomerDetail({super.key, required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return AlertDialog(
      title: Text(customer.nombreRazon),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Identificación: ${customer.identificacion}'),
          SizedBox(height: spacing.xs),
          if (customer.email != null) Text('Email: ${customer.email}'),
          if (customer.telefono != null)
            Text('Teléfono: ${customer.telefono}'),
          if (customer.direccion != null)
            Text('Dirección: ${customer.direccion}'),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
