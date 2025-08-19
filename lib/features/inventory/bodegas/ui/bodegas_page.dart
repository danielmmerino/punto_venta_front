import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/bodegas_controller.dart';
import '../data/models/bodega.dart';
import 'bodega_form.dart';

class BodegasPage extends HookConsumerWidget {
  const BodegasPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final state = ref.watch(bodegasControllerProvider);
    final searchCtrl = useTextEditingController();
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      ref.read(bodegasControllerProvider.notifier).load();
      return null;
    }, const []);

    return Padding(
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
                    .read(bodegasControllerProvider.notifier)
                    .load(filters: {'search': value});
              });
            },
          ),
          SizedBox(height: spacing.md),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : state.items.isEmpty
                    ? const Center(child: Text('Sin bodegas'))
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
                                  DataColumn(label: Text('Zona')),
                                  DataColumn(label: Text('Activa')),
                                  DataColumn(label: Text('Acciones')),
                                ],
                                rows: state.items
                                    .map(
                                      (b) => DataRow(cells: [
                                        DataCell(Text(b.codigo)),
                                        DataCell(Text(b.nombre)),
                                        DataCell(Text(b.zona ?? '-')),
                                        DataCell(Switch(
                                          value: b.activo,
                                          onChanged: (_) {},
                                        )),
                                        DataCell(Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.edit),
                                              onPressed: () => _openForm(context, ref, b),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.delete),
                                              onPressed: () => ref
                                                  .read(bodegasControllerProvider
                                                      .notifier)
                                                  .remove(b.id),
                                            ),
                                          ],
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
                                final b = state.items[index];
                                return ListTile(
                                  title: Text(b.nombre),
                                  subtitle: Text(b.codigo),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Switch(
                                        value: b.activo,
                                        onChanged: (_) {},
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () => _openForm(context, ref, b),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete),
                                        onPressed: () => ref
                                            .read(bodegasControllerProvider
                                                .notifier)
                                            .remove(b.id),
                                      ),
                                    ],
                                  ),
                                  onTap: () => _openForm(context, ref, b),
                                );
                              },
                            );
                          }
                        },
                      ),
          ),
          SizedBox(height: spacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _openForm(context, ref, null),
              icon: const Icon(Icons.add),
              label: const Text('Nueva bodega'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openForm(
      BuildContext context, WidgetRef ref, Bodega? initial) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => BodegaForm(initial: initial),
    );
    if (result != null) {
      if (initial == null) {
        await ref.read(bodegasControllerProvider.notifier).create(result);
      } else {
        await ref
            .read(bodegasControllerProvider.notifier)
            .update(initial.id, result);
      }
    }
  }
}
