import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/theme/app_spacing.dart';
import '../data/models/recipe_line.dart';

class RecipeLineTile extends HookWidget {
  const RecipeLineTile({
    super.key,
    required this.line,
    required this.onChanged,
    required this.onDelete,
  });

  final RecipeLine line;
  final ValueChanged<RecipeLine> onChanged;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final qtyCtrl = useTextEditingController(text: line.cantidad.toString());
    final mermaCtrl =
        useTextEditingController(text: line.mermaPorcentaje.toString());

    useEffect(() {
      qtyCtrl.text = line.cantidad.toString();
      mermaCtrl.text = line.mermaPorcentaje.toString();
      return null;
    }, [line]);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: spacing.sm),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(line.insumoNombre ?? ''),
                if (line.insumoCodigo != null)
                  Text(
                    line.insumoCodigo!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                if (line.unidadCodigo != null)
                  Padding(
                    padding: EdgeInsets.only(top: spacing.xs),
                    child: Chip(label: Text(line.unidadCodigo!)),
                  ),
              ],
            ),
          ),
          SizedBox(
            width: spacing.xl * 3,
            child: TextField(
              controller: qtyCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Cantidad'),
              onChanged: (v) {
                final value = double.tryParse(v) ?? line.cantidad;
                onChanged(line.copyWith(cantidad: value));
              },
            ),
          ),
          SizedBox(width: spacing.sm),
          SizedBox(
            width: spacing.xl * 3,
            child: TextField(
              controller: mermaCtrl,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'Merma %'),
              onChanged: (v) {
                final value = double.tryParse(v) ?? line.mermaPorcentaje;
                onChanged(line.copyWith(mermaPorcentaje: value));
              },
            ),
          ),
          IconButton(onPressed: onDelete, icon: const Icon(Icons.delete)),
        ],
      ),
    );
  }
}
