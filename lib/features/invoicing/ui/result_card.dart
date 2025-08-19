import 'package:flutter/material.dart';

import '../../invoices/data/models/cancel_result.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.result,
    required this.onView,
    required this.onClose,
  });

  final CancelInvoiceResult result;
  final VoidCallback onView;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NC generada',
                style: TextStyle(fontWeight: FontWeight.bold)),
            if (result.ncNumero != null)
              Padding(
                padding: EdgeInsets.only(top: spacing.sm),
                child: Text('Número: ${result.ncNumero}'),
              ),
            Padding(
              padding: EdgeInsets.only(top: spacing.sm),
              child: Text('Estado SRI: ${result.estadoSri}'),
            ),
            if (result.mensajes.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: spacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: result.mensajes
                      .map((m) => Text('${m.codigo}: ${m.detalle}'))
                      .toList(),
                ),
              ),
            SizedBox(height: spacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onView, child: const Text('Ver NC')),
                SizedBox(width: spacing.sm),
                ElevatedButton(onPressed: onClose, child: const Text('Cerrar')),
              ],
            )
          ],
        ),
      ),
    );
  }
}
