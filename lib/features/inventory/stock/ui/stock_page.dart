import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../bodegas/controllers/bodegas_controller.dart';
import '../../bodegas/data/models/bodega.dart';
import '../controllers/stock_controller.dart';
import '../data/stock_repository.dart';
import '../../../products/data/models/product.dart';

class StockPage extends HookConsumerWidget {
  const StockPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final bodegasState = ref.watch(bodegasControllerProvider);
    final stockState = ref.watch(stockControllerProvider);
    final selectedBodega = useState<Bodega?>(null);
    final selectedProduct = useState<Product?>(null);
    final onlyAvailable = useState(false);
    final productTextCtrl = useTextEditingController();
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      ref.read(bodegasControllerProvider.notifier).load();
      return null;
    }, const []);

    useEffect(() {
      if (selectedBodega.value != null || selectedProduct.value != null) {
        ref.read(stockControllerProvider.notifier).load(
              bodegaId: selectedBodega.value?.id,
              productoId: selectedProduct.value?.id,
              soloConStock: onlyAvailable.value,
            );
      }
      return null;
    }, [selectedBodega.value, selectedProduct.value, onlyAvailable.value]);

    return Padding(
      padding: EdgeInsets.all(spacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButton<Bodega>(
                  isExpanded: true,
                  value: selectedBodega.value,
                  hint: const Text('Seleccionar bodega'),
                  items: bodegasState.items
                      .map((b) => DropdownMenuItem(
                            value: b,
                            child: Text(b.nombre),
                          ))
                      .toList(),
                  onChanged: (b) => selectedBodega.value = b,
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Autocomplete<Product>(
                  displayStringForOption: (p) => '${p.codigo} - ${p.nombre}',
                  optionsBuilder: (text) {
                    final query = text.text;
                    if (query.length < 2) return const Iterable<Product>.empty();
                    debounce.value?.cancel();
                    debounce.value =
                        Timer(const Duration(milliseconds: 300), () {});
                    final result =
                        ref.watch(productsSearchProvider(query)).value ?? [];
                    return result;
                  },
                  onSelected: (p) {
                    selectedProduct.value = p;
                    productTextCtrl.text = '${p.codigo} - ${p.nombre}';
                  },
                  fieldViewBuilder: (context, ctrl, focus, onFieldSubmitted) {
                    productTextCtrl.value = ctrl.value;
                    return TextField(
                      controller: ctrl,
                      focusNode: focus,
                      decoration: const InputDecoration(
                        hintText: 'Buscar producto',
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Checkbox(
                value: onlyAvailable.value,
                onChanged: (v) => onlyAvailable.value = v ?? false,
              ),
              const Text('Solo con stock > 0'),
            ],
          ),
          SizedBox(height: spacing.md),
          Expanded(
            child: stockState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : stockState.items.isEmpty
                    ? const Center(child: Text('Sin resultados'))
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
                                  DataColumn(label: Text('U.M.')),
                                  DataColumn(label: Text('Stock')),
                                  DataColumn(label: Text('Reservado')),
                                  DataColumn(label: Text('Disponible')),
                                ],
                                rows: stockState.items
                                    .map(
                                      (s) => DataRow(cells: [
                                        DataCell(Text(s.codigo)),
                                        DataCell(Text(s.nombre)),
                                        DataCell(Text(s.unidadCodigo)),
                                        DataCell(Text(s.stock.toString())),
                                        DataCell(Text(
                                            (s.reservado ?? 0).toString())),
                                        DataCell(Text(
                                            (s.disponible ?? s.stock).toString())),
                                      ]),
                                    )
                                    .toList(),
                              ),
                            );
                          } else {
                            return ListView.builder(
                              itemCount: stockState.items.length,
                              itemBuilder: (context, index) {
                                final s = stockState.items[index];
                                return ListTile(
                                  title: Text(s.nombre),
                                  subtitle: Text(s.codigo),
                                  trailing: Text(s.stock.toString()),
                                );
                              },
                            );
                          }
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
