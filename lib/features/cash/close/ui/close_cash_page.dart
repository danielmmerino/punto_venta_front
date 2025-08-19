import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/close_cash_controller.dart';
import '../../common/cash_repository.dart';
import 'method_count_row.dart';
import 'totals_footer.dart';

class CloseCashPage extends ConsumerWidget {
  const CloseCashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(closeCashControllerProvider);
    if (state.closed) {
      return ActaView(pdfUrl: state.pdfUrl);
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Cierre de caja')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: state.methods
                  .map((m) => MethodCountRow(
                      method: m,
                      onChanged: (v) =>
                          ref.read(closeCashControllerProvider.notifier).updateCount(m.metodoId, v)))
                  .toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: TotalsFooter(),
          )
        ],
      ),
    );
  }
}

class ActaView extends StatelessWidget {
  const ActaView({super.key, this.pdfUrl});
  final String? pdfUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Acta de cierre')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Imprimir')),
            const SizedBox(height: 8),
            ElevatedButton(
                onPressed: pdfUrl != null ? () {} : null,
                child: const Text('Descargar PDF')),
          ],
        ),
      ),
    );
  }
}
