import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/vendors_controller.dart';
import '../data/models/vendor.dart';
import 'vendor_detail.dart';
import 'vendor_form.dart';

class VendorsPage extends HookConsumerWidget {
  const VendorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final controller = ref.read(vendorsControllerProvider.notifier);
    final state = ref.watch(vendorsControllerProvider);
    final search = useTextEditingController();
    final timer = useRef<Timer?>(null);
    final filter = useState<bool?>(null);

    useEffect(() {
      controller.load();
      void listener() {
        timer.value?.cancel();
        timer.value = Timer(const Duration(milliseconds: 400), () {
          controller.load(params: {
            'search': search.text,
            if (filter.value != null) 'activo': filter.value! ? 1 : 0,
          });
        });
      }

      search.addListener(listener);
      return () {
        timer.value?.cancel();
        search.removeListener(listener);
      };
    }, [filter.value]);

    Future<void> openForm([Vendor? vendor]) async {
      final data = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => VendorForm(initial: vendor),
      );
      if (data != null) {
        try {
          if (vendor == null) {
            await controller.create(data);
          } else {
            await controller.update(vendor.id, data);
          }
        } on Map<String, List<String>> catch (errors) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errors.values.first.first)),
          );
        }
      }
    }

    Future<void> showDetail(Vendor v) async {
      final action = await showDialog<String>(
        context: context,
        builder: (_) => VendorDetail(vendor: v),
      );
      if (action == 'edit') {
        await openForm(v);
      } else if (action == 'delete') {
        final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirmar'),
                content: const Text('¿Eliminar proveedor?'),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(ctx, false),
                      child: const Text('No')),
                  FilledButton(
                      onPressed: () => Navigator.pop(ctx, true),
                      child: const Text('Sí')),
                ],
              ),
            ) ??
            false;
        if (confirm) {
          await controller.remove(v.id);
        }
      }
    }

    Widget buildList() {
      return LayoutBuilder(
        builder: (context, constraints) {
          final items = state.vendors;
          if (constraints.maxWidth < 600) {
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final v = items[index];
                return ListTile(
                  title: Text(v.razonSocial),
                  subtitle: Text(v.email ?? v.telefono ?? ''),
                  trailing: Text(v.activo ? 'Activo' : 'Inactivo'),
                  onTap: () => showDetail(v),
                );
              },
            );
          }
          return DataTable(
            columns: const [
              DataColumn(label: Text('Razón social')),
              DataColumn(label: Text('RUC')),
              DataColumn(label: Text('Email/Teléfono')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: [
              for (final v in items)
                DataRow(cells: [
                  DataCell(Text(v.razonSocial)),
                  DataCell(Text(v.ruc ?? '')),
                  DataCell(Text(v.email ?? v.telefono ?? '')),
                  DataCell(Text(v.activo ? 'Activo' : 'Inactivo')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => showDetail(v),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => openForm(v),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirmar'),
                                  content: const Text(
                                      '¿Eliminar proveedor?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: const Text('No'),
                                    ),
                                    FilledButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: const Text('Sí'),
                                    ),
                                  ],
                                ),
                              ) ??
                              false;
                          if (confirm) {
                            await controller.remove(v.id);
                          }
                        },
                      ),
                    ],
                  )),
                ])
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: search,
                    decoration: const InputDecoration(hintText: 'Buscar'),
                  ),
                ),
                SizedBox(width: spacing.sm),
                DropdownButton<bool?>(
                  value: filter.value,
                  hint: const Text('Estado'),
                  onChanged: (v) => filter.value = v,
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Todos')),
                    DropdownMenuItem(value: true, child: Text('Activos')),
                    DropdownMenuItem(value: false, child: Text('Inactivos')),
                  ],
                ),
                SizedBox(width: spacing.sm),
                FilledButton.icon(
                  onPressed: () => openForm(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo'),
                ),
              ],
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : buildList(),
          ),
        ],
      ),
    );
  }
}
