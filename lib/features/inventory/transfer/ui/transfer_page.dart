import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../bodegas/controllers/bodegas_controller.dart';
import '../../bodegas/data/models/bodega.dart';
import '../../common/lines_table.dart';
import '../controllers/transfer_controller.dart';

class TransferPage extends HookConsumerWidget {
  const TransferPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final bodegasState = ref.watch(bodegasControllerProvider);
    final transferState = ref.watch(transferControllerProvider);
    final origen = useState<Bodega?>(null);
    final destino = useState<Bodega?>(null);

    useEffect(() {
      Future.microtask(
          () => ref.read(bodegasControllerProvider.notifier).load());
      return null;
    }, const []);

    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<Bodega>(
                  isExpanded: true,
                  value: origen.value,
                  hint: const Text('Origen'),
                  items: bodegasState.items
                      .map((b) => DropdownMenuItem(value: b, child: Text(b.nombre)))
                      .toList(),
                  onChanged: (b) => origen.value = b,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: DropdownButton<Bodega>(
                  isExpanded: true,
                  value: destino.value,
                  hint: const Text('Destino'),
                  items: bodegasState.items
                      .map((b) => DropdownMenuItem(value: b, child: Text(b.nombre)))
                      .toList(),
                  onChanged: (b) => destino.value = b,
                ),
              ),
            ],
          ),
          SizedBox(height: spacing.md),
          Expanded(
            child: SingleChildScrollView(
              child: LinesTable(
                lines: transferState.lines,
                onAdd: () =>
                    ref.read(transferControllerProvider.notifier).addLine(),
                onRemove: (i) =>
                    ref.read(transferControllerProvider.notifier).removeLine(i),
                onProduct: (i, p) => ref
                    .read(transferControllerProvider.notifier)
                    .updateProduct(i, p),
                onQuantity: (i, q) => ref
                    .read(transferControllerProvider.notifier)
                    .updateQuantity(i, q),
                showCost: false,
                allowNegative: false,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: transferState.isSaving
                  ? null
                  : () async {
                      if (origen.value == null || destino.value == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Seleccione bodegas')),
                        );
                        return;
                      }
                      final ok = await ref
                          .read(transferControllerProvider.notifier)
                          .submit(
                              origen: origen.value!.id,
                              destino: destino.value!.id);
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Traspaso creado')),
                        );
                      }
                    },
              child: const Text('Guardar traspaso'),
            ),
          ),
        ],
      ),
    );
  }
}
