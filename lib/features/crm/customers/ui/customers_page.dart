import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/customers_controller.dart';
import '../data/models/customer.dart';
import 'customer_detail.dart';
import 'customer_form.dart';

class CustomersPage extends HookConsumerWidget {
  const CustomersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final controller = ref.read(customersControllerProvider.notifier);
    final state = ref.watch(customersControllerProvider);
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

    Future<void> openForm([Customer? customer]) async {
      final data = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => CustomerForm(initial: customer),
      );
      if (data != null) {
        try {
          if (customer == null) {
            await controller.create(data);
          } else {
            await controller.update(customer.id, data);
          }
        } on Map<String, List<String>> catch (errors) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errors.values.first.first)),
          );
        }
      }
    }

    Future<void> showDetail(Customer c) async {
      final action = await showDialog<String>(
        context: context,
        builder: (_) => CustomerDetail(customer: c),
      );
      if (action == 'edit') {
        await openForm(c);
      } else if (action == 'delete') {
        final confirm = await showDialog<bool>(
              context: context,
              builder: (ctx) => AlertDialog(
                title: const Text('Confirmar'),
                content: const Text('¿Eliminar cliente?'),
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
          await controller.remove(c.id);
        }
      }
    }

    Widget buildList() {
      return LayoutBuilder(
        builder: (context, constraints) {
          final items = state.customers;
          if (constraints.maxWidth < 600) {
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final c = items[index];
                return ListTile(
                  title: Text(c.nombreRazon),
                  subtitle: Text(c.email ?? c.telefono ?? ''),
                  trailing: Text(c.activo ? 'Activo' : 'Inactivo'),
                  onTap: () => showDetail(c),
                );
              },
            );
          }
          return DataTable(
            columns: const [
              DataColumn(label: Text('Nombre/Razón')),
              DataColumn(label: Text('Identificación')),
              DataColumn(label: Text('Email/Teléfono')),
              DataColumn(label: Text('Estado')),
              DataColumn(label: Text('Acciones')),
            ],
            rows: [
              for (final c in items)
                DataRow(cells: [
                  DataCell(Text(c.nombreRazon)),
                  DataCell(Text(c.identificacion ?? '')),
                  DataCell(Text(c.email ?? c.telefono ?? '')),
                  DataCell(Text(c.activo ? 'Activo' : 'Inactivo')),
                  DataCell(Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),
                        onPressed: () => showDetail(c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => openForm(c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirm = await showDialog<bool>(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  title: const Text('Confirmar'),
                                  content:
                                      const Text('¿Eliminar cliente?'),
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
                            await controller.remove(c.id);
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
      appBar: AppBar(title: const Text('Clientes')),
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
