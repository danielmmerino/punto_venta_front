import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../data/models/producto_vendido.dart';
import 'package:intl/intl.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key, required this.producto});

  final ProductoVendido producto;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final currency = NumberFormat.simpleCurrency();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.xs),
      child: ListTile(
        title: Text(producto.nombre),
        subtitle: Text('${producto.unidades} unidades'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(currency.format(producto.monto)),
            if (producto.margen != null)
              Text('Margen ${currency.format(producto.margen!)}',
                  style: TextStyle(color: colors.n600, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
