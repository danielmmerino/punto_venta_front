import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../bodegas/controllers/bodegas_controller.dart';
import '../../bodegas/data/models/bodega.dart';
import '../../common/lines_table.dart';
import '../../common/reason_field.dart';
import '../controllers/adjust_controller.dart';

class AdjustPage extends HookConsumerWidget {
  const AdjustPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final bodegasState = ref.watch(bodegasControllerProvider);
    final adjustState = ref.watch(adjustControllerProvider);
    final selectedBodega = useState<Bodega?>(null);
    final motivoCtrl = useTextEditingController();

    useEffect(() {
      ref.read(bodegasControllerProvider.notifier).load();
      return null;
    }, const []);

    final totalQty = adjustState.lines
        .fold<double>(0, (prev, e) => prev + e.quantity);

    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButton<Bodega>(
            isExpanded: true,
            value: selectedBodega.value,
            hint: const Text('Seleccionar bodega'),
            items: bodegasState.items
                .map(
                  (b) => DropdownMenuItem(
                    value: b,
                    child: Text(b.nombre),
                  ),
                )
                .toList(),
            onChanged: (b) => selectedBodega.value = b,
          ),
          SizedBox(height: spacing.md),
          ReasonField(controller: motivoCtrl),
          SizedBox(height: spacing.md),
          Expanded(
            child: SingleChildScrollView(
              child: LinesTable(
                lines: adjustState.lines,
                onAdd: () =>
                    ref.read(adjustControllerProvider.notifier).addLine(),
                onRemove: (i) =>
                    ref.read(adjustControllerProvider.notifier).removeLine(i),
                onProduct: (i, p) => ref
                    .read(adjustControllerProvider.notifier)
                    .updateProduct(i, p),
                onQuantity: (i, q) => ref
                    .read(adjustControllerProvider.notifier)
                    .updateQuantity(i, q),
                onCost: (i, c) => ref
                    .read(adjustControllerProvider.notifier)
                    .updateCost(i, c),
                showCost: true,
                allowNegative: true,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total: $totalQty'),
              ElevatedButton(
                onPressed: adjustState.isSaving
                    ? null
                    : () async {
                        if (selectedBodega.value == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Seleccione bodega')),
                          );
                          return;
                        }
                        final ok = await ref
                            .read(adjustControllerProvider.notifier)
                            .submit(
                              bodegaId: selectedBodega.value!.id,
                              motivo: motivoCtrl.text,
                            );
                        if (ok) {
                          motivoCtrl.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ajuste creado')),
                          );
                        }
                      },
                child: const Text('Guardar ajuste'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
