import 'package:flutter/material.dart';

import '../../../core/theme/app_spacing.dart';
import '../../products/data/models/product.dart';
import 'line_item.dart';
import 'product_autocomplete_field.dart';
import 'quantity_field.dart';

class LinesTable extends StatelessWidget {
  const LinesTable({
    super.key,
    required this.lines,
    required this.onAdd,
    required this.onRemove,
    required this.onProduct,
    required this.onQuantity,
    this.onCost,
    this.showCost = false,
    this.allowNegative = false,
  });

  final List<LineItem> lines;
  final VoidCallback onAdd;
  final void Function(int) onRemove;
  final void Function(int, Product) onProduct;
  final void Function(int, double) onQuantity;
  final void Function(int, double?)? onCost;
  final bool showCost;
  final bool allowNegative;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Column(
      children: [
        for (var i = 0; i < lines.length; i++)
          Padding(
            padding: EdgeInsets.only(bottom: spacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: ProductAutocompleteField(
                    initialValue: lines[i].product,
                    onSelected: (p) => onProduct(i, p),
                  ),
                ),
                SizedBox(width: spacing.sm),
                Expanded(
                  flex: 2,
                  child: QuantityField(
                    value: lines[i].quantity,
                    allowNegative: allowNegative,
                    onChanged: (v) => onQuantity(i, v),
                  ),
                ),
                if (showCost) ...[
                  SizedBox(width: spacing.sm),
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: lines[i].cost != null
                          ? lines[i].cost.toString()
                          : '',
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(hintText: 'Costo'),
                      onChanged: (v) => onCost?.call(i, double.tryParse(v)),
                    ),
                  ),
                ],
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => onRemove(i),
                ),
              ],
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add),
            label: const Text('Agregar línea'),
          ),
        ),
      ],
    );
  }
}
