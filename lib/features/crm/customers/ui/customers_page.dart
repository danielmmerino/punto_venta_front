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

    useEffect(() {
      controller.load();
      void listener() {
        timer.value?.cancel();
        timer.value = Timer(const Duration(milliseconds: 400), () {
          controller.load(params: {'search': search.text});
        });
      }

      search.addListener(listener);
      return () {
        timer.value?.cancel();
        search.removeListener(listener);
      };
    }, []);

    Future<void> openForm([Customer? customer]) async {
      final data = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => CustomerForm(initial: customer),
      );
      if (data != null) {
        if (customer == null) {
          await controller.create(data);
        } else {
          await controller.update(customer.id, data);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: TextField(
              controller: search,
              decoration: const InputDecoration(hintText: 'Buscar'),
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: state.customers.length,
                    itemBuilder: (context, index) {
                      final c = state.customers[index];
                      return ListTile(
                        title: Text(c.nombreRazon),
                        subtitle: Text(c.email ?? c.telefono ?? ''),
                        trailing: Text(c.activo ? 'Activo' : 'Inactivo'),
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => CustomerDetail(customer: c),
                        ),
                        onLongPress: () => openForm(c),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
