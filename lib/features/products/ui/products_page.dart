import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/ui/menu_drawer.dart';
import '../controllers/products_controller.dart';
import '../data/models/product.dart';
import 'product_form.dart';

class ProductsPage extends HookConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final state = ref.watch(productsControllerProvider);
    final searchCtrl = useTextEditingController();
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      ref.read(productsControllerProvider.notifier).load();
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Productos'),
      ),
      drawer: const MenuDrawer(),
      body: Padding(
        padding: EdgeInsets.all(spacing.md),
        child: Column(
          children: [
            TextField(
              controller: searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Buscar por nombre o código',
              ),
              onChanged: (value) {
                debounce.value?.cancel();
                debounce.value = Timer(const Duration(milliseconds: 400), () {
                  ref
                      .read(productsControllerProvider.notifier)
                      .load(filters: {'search': value});
                });
              },
            ),
            SizedBox(height: spacing.md),
            Expanded(
              child: state.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : state.items.isEmpty
                      ? const Center(child: Text('Sin productos'))
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isWide = constraints.maxWidth >= 600;
                            if (isWide) {
                              return SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: DataTable(
                                  columns: const [
                                    DataColumn(label: Text('Código')),
                                    DataColumn(label: Text('Nombre')),
                                    DataColumn(label: Text('Precio')),
                                    DataColumn(label: Text('Estado')),
                                  ],
                                  rows: state.items
                                      .map(
                                        (p) => DataRow(cells: [
                                          DataCell(Text(p.codigo)),
                                          DataCell(Text(p.nombre)),
                                          DataCell(Text(
                                              p.precio.toStringAsFixed(2))),
                                          DataCell(Switch(
                                            value: p.activo,
                                            onChanged: (v) {
                                              ref
                                                  .read(productsControllerProvider
                                                      .notifier)
                                                  .toggleActive(p.id, v);
                                            },
                                          )),
                                        ]),
                                      )
                                      .toList(),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: state.items.length,
                                itemBuilder: (context, index) {
                                  final p = state.items[index];
                                  return ListTile(
                                    title: Text(p.nombre),
                                    subtitle: Text(p.codigo),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                            '\$${p.precio.toStringAsFixed(2)}'),
                                        Switch(
                                          value: p.activo,
                                          onChanged: (v) {
                                            ref
                                                .read(productsControllerProvider
                                                    .notifier)
                                                .toggleActive(p.id, v);
                                          },
                                        ),
                                      ],
                                    ),
                                    onTap: () async {
                                      final result =
                                          await showDialog<Map<String, dynamic>>(
                                        context: context,
                                        builder: (_) => ProductForm(initial: p),
                                      );
                                      if (result != null) {
                                        await ref
                                            .read(productsControllerProvider
                                                .notifier)
                                            .update(p.id, result);
                                      }
                                    },
                                  );
                                },
                              );
                            }
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog<Map<String, dynamic>>(
            context: context,
            builder: (_) => const ProductForm(),
          );
          if (result != null) {
            await ref
                .read(productsControllerProvider.notifier)
                .create(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
