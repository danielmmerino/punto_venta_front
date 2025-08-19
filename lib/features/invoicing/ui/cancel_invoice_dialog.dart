import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../invoices/data/models/cancel_result.dart';
import '../controllers/cancel_invoice_controller.dart';
import 'result_card.dart';

class CancelInvoiceDialog extends HookConsumerWidget {
  const CancelInvoiceDialog({super.key, required this.invoiceId});

  final int invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final motivoCtrl = useTextEditingController();
    final state = ref.watch(cancelInvoiceControllerProvider);

    Widget buildForm() {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: motivoCtrl,
            maxLines: 3,
            decoration: const InputDecoration(labelText: 'Motivo'),
            validator: validateMotivo,
          ),
          if (state.error != null)
            Padding(
              padding: EdgeInsets.only(top: spacing.sm),
              child: Text(
                state.error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
          SizedBox(height: spacing.lg),
          ElevatedButton(
            onPressed: state.isSending
                ? null
                : () async {
                    if (formKey.currentState!.validate()) {
                      await ref
                          .read(cancelInvoiceControllerProvider.notifier)
                          .submit(invoiceId, motivoCtrl.text);
                    }
                  },
            child: state.isSending
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Confirmar anulación'),
          ),
        ],
      );
    }

    Widget buildResult(CancelInvoiceResult result) {
      return ResultCard(
        result: result,
        onView: () {
          context.go('/notas-credito/${result.notaCreditoId}');
        },
        onClose: () => Navigator.of(context).pop(),
      );
    }

    final isWide = MediaQuery.of(context).size.width >= 600;
    final content = state.result != null
        ? buildResult(state.result!)
        : buildForm();

    if (isWide) {
      return AlertDialog(
        title: const Text('Anular factura'),
        content: Form(key: formKey, child: content),
      );
    }

    return Dialog.fullscreen(
      child: Scaffold(
        appBar: AppBar(title: const Text('Anular factura')),
        body: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Form(key: formKey, child: content),
        ),
      ),
    );
  }
}
