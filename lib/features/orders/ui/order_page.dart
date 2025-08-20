import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/ui/menu_drawer.dart';
import '../controllers/order_controller.dart';

class OrderPage extends HookConsumerWidget {
  const OrderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderControllerProvider);

    useEffect(() {
      Future(() =>
          ref.read(orderControllerProvider.notifier).loadMenu());
      return null;
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('Tomar pedido')),
      drawer: const MenuDrawer(),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.menu.length,
                    itemBuilder: (context, index) {
                      final item = state.menu[index];
                      return Card(
                        child: InkWell(
                          onTap: () => ref
                              .read(orderControllerProvider.notifier)
                              .add(item),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(item.nombre,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium),
                                const Spacer(),
                                Text('\$${item.precioVenta.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: 300,
                  color: Colors.grey.shade200,
                  child: Column(
                    children: [
                      const ListTile(title: Text('Pedido')),
                      Expanded(
                        child: ListView.builder(
                          itemCount: state.items.length,
                          itemBuilder: (context, index) {
                            final line = state.items[index];
                            return ListTile(
                              title: Text(line.item.nombre),
                              subtitle: Text(
                                  '${line.quantity} x \$${line.item.precioVenta.toStringAsFixed(2)}'),
                              trailing: Text(
                                  '\$${(line.item.precioVenta * line.quantity).toStringAsFixed(2)}'),
                            );
                          },
                        ),
                      ),
                      const Divider(height: 1),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('Total',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Text(
                              '\$${state.total.toStringAsFixed(2)}',
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
