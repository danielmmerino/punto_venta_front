import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../products/data/models/product.dart';
import '../../products/data/products_repository.dart';

class AutocompleteInsumoField extends HookConsumerWidget {
  const AutocompleteInsumoField({super.key, required this.onSelected});

  final ValueChanged<Product> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = useTextEditingController();
    final results = useState<List<Product>>([]);
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      void listener() {
        debounce.value?.cancel();
        debounce.value = Timer(const Duration(milliseconds: 400), () async {
          final repo = ref.read(productsRepositoryProvider);
          final list = await repo.searchInsumos(ctrl.text);
          results.value = list;
        });
      }

      ctrl.addListener(listener);
      return () {
        ctrl.removeListener(listener);
        debounce.value?.cancel();
      };
    }, [ctrl]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: ctrl,
          decoration: const InputDecoration(labelText: 'Insumo'),
        ),
        ...results.value.map(
          (p) => ListTile(
            title: Text(p.nombre),
            subtitle: Text(p.codigo),
            onTap: () {
              onSelected(p);
              ctrl.text = '${p.nombre} (${p.codigo})';
              results.value = [];
            },
          ),
        ),
      ],
    );
  }
}
