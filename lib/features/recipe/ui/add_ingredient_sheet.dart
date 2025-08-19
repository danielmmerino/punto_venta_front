import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../products/data/models/product.dart';
import '../data/models/recipe_line.dart';
import '../widgets/autocomplete_insumo_field.dart';

class AddIngredientSheet extends HookConsumerWidget {
  const AddIngredientSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final selected = useState<Product?>(null);
    final qtyCtrl = useTextEditingController(text: '1');
    final mermaCtrl = useTextEditingController(text: '0');

    return Padding(
      padding: EdgeInsets.only(
        left: spacing.md,
        right: spacing.md,
        top: spacing.md,
        bottom: MediaQuery.of(context).viewInsets.bottom + spacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AutocompleteInsumoField(onSelected: (p) => selected.value = p),
          SizedBox(height: spacing.md),
          TextField(
            controller: qtyCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Cantidad'),
          ),
          SizedBox(height: spacing.md),
          TextField(
            controller: mermaCtrl,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(labelText: 'Merma %'),
          ),
          SizedBox(height: spacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              SizedBox(width: spacing.md),
              FilledButton(
                onPressed: () {
                  final p = selected.value;
                  final qty = double.tryParse(qtyCtrl.text) ?? 0;
                  final merma = double.tryParse(mermaCtrl.text) ?? 0;
                  if (p == null || qty <= 0 || merma < 0 || merma > 100) {
                    Navigator.pop(context);
                    return;
                  }
                  Navigator.pop(
                    context,
                    RecipeLine(
                      insumoId: p.id,
                      insumoCodigo: p.codigo,
                      insumoNombre: p.nombre,
                      unidadId: p.unidadId,
                      unidadCodigo: p.unidadCodigo,
                      cantidad: qty,
                      mermaPorcentaje: merma,
                    ),
                  );
                },
                child: const Text('Agregar'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
