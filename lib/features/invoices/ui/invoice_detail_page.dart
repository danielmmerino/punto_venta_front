import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../controllers/invoice_detail_controller.dart';
import '../controllers/invoice_detail_state.dart';
import '../data/models/invoice.dart';
import 'widgets/status_chip.dart';

class InvoiceDetailPage extends HookConsumerWidget {
  const InvoiceDetailPage({super.key, required this.id});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final controller = ref.read(invoiceDetailControllerProvider.notifier);
    final state = ref.watch(invoiceDetailControllerProvider);

    useEffect(() {
      controller.load(id);
      return null;
    }, const []);

    final invoice = state.invoice;
    return Scaffold(
      appBar: AppBar(
        title: Text('Factura #${invoice?.numero ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => controller.downloadPdf(id),
          ),
          IconButton(
            icon: const Icon(Icons.code),
            onPressed: () => controller.downloadXml(id),
          ),
        ],
      ),
      body: state.isLoading && invoice == null
          ? const Center(child: CircularProgressIndicator())
          : invoice == null
              ? const Center(child: Text('No encontrada'))
              : Padding(
                  padding: EdgeInsets.all(spacing.md),
                  child: ListView(
                    children: [
                      _Header(invoice: invoice),
                      SizedBox(height: spacing.lg),
                      _Totals(totals: invoice.totales),
                      SizedBox(height: spacing.lg),
                      if (state.canEmit)
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => controller.emit(id),
                          child: state.isLoading
                              ? const CircularProgressIndicator()
                              : const Text('Emitir ahora'),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.invoice});

  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text(invoice.numero ?? 'Borrador')),
            StatusChip(estado: invoice.estadoSri),
          ],
        ),
        if (invoice.cliente != null) ...[
          SizedBox(height: spacing.sm),
          Text('${invoice.cliente!.nombre} (${invoice.cliente!.identificacion})'),
        ],
      ],
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.totals});

  final InvoiceTotals totals;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Subtotal: ${totals.subtotal.toStringAsFixed(2)}'),
        Text('Descuento: ${totals.descuento.toStringAsFixed(2)}'),
        Text('IVA: ${totals.iva.toStringAsFixed(2)}'),
        Text('Total: ${totals.total.toStringAsFixed(2)}'),
      ],
    );
  }
}
