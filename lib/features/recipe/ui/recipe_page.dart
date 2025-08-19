import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../products/data/models/product.dart';
import '../controllers/recipe_controller.dart';
import '../data/models/recipe_line.dart';
import '../widgets/recipe_line_tile.dart';
import 'add_ingredient_sheet.dart';

class RecipePage extends HookConsumerWidget {
  const RecipePage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final state = ref.watch(recipeControllerProvider);
    final controller = ref.read(recipeControllerProvider.notifier);

    useEffect(() {
      controller.load(product.id);
      return null;
    }, const []);

    Future<void> _add() async {
      final line = await showModalBottomSheet<RecipeLine>(
        context: context,
        isScrollControlled: true,
        builder: (_) => const AddIngredientSheet(),
      );
      if (line != null) {
        final err = await controller.addLine(line);
        if (err != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err)),
          );
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Receta de ${product.nombre}'),
        actions: [
          if (state.dirty)
            TextButton(
              onPressed: () => controller.saveAll(product.id),
              child: const Text('Guardar'),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _add,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(product.codigo),
            Text(product.categoriaNombre ?? ''),
            Text(product.unidadCodigo ?? ''),
            Text('\$${product.precio.toStringAsFixed(2)}'),
            SizedBox(height: spacing.lg),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.lines.isEmpty
                      ? const Center(child: Text('Aún no has agregado insumos'))
                      : ListView.builder(
                          itemCount: state.lines.length,
                          itemBuilder: (context, index) {
                            final line = state.lines[index];
                            return RecipeLineTile(
                              line: line,
                              onChanged: controller.updateLine,
                              onDelete: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Eliminar'),
                                    content: const Text(
                                        '¿Eliminar este insumo de la receta?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancelar'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Eliminar'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  await controller.deleteLine(
                                      product.id, line.insumoId);
                                }
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
