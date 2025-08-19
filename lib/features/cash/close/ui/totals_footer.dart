import 'package:flutter/material.dart';

import '../controllers/close_cash_controller.dart';

class TotalsFooter extends ConsumerWidget {
  const TotalsFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(closeCashControllerProvider);
    final controller = ref.read(closeCashControllerProvider.notifier);
    return Column(
      children: [
        Text('Σ Esperado: ${state.totalEsperado.toStringAsFixed(2)}'),
        Text('Σ Conteo: ${state.totalConteo.toStringAsFixed(2)}'),
        Text('Σ Diferencia: ${state.totalDiferencia.toStringAsFixed(2)}'),
        const SizedBox(height: 8),
        ElevatedButton(
          onPressed: state.isClosing ? null : () => controller.close(),
          child: const Text('Cerrar caja'),
        ),
        if (state.error != null) Text(state.error!),
      ],
    );
  }
}
