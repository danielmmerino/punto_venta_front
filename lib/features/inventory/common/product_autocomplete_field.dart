import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../stock/data/stock_repository.dart';
import '../../products/data/models/product.dart';

class ProductAutocompleteField extends HookConsumerWidget {
  const ProductAutocompleteField({
    super.key,
    this.initialValue,
    required this.onSelected,
  });

  final Product? initialValue;
  final ValueChanged<Product> onSelected;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ctrl = useTextEditingController();
    final debounce = useRef<Timer?>(null);

    useEffect(() {
      if (initialValue != null) {
        ctrl.text = '${initialValue!.codigo} - ${initialValue!.nombre}';
      }
      return null;
    }, const []);

    return Autocomplete<Product>(
      displayStringForOption: (p) => '${p.codigo} - ${p.nombre}',
      optionsBuilder: (text) {
        final query = text.text;
        if (query.length < 2) return const Iterable<Product>.empty();
        debounce.value?.cancel();
        debounce.value = Timer(const Duration(milliseconds: 300), () {});
        final result = ref.watch(productsSearchProvider(query)).value ?? [];
        return result;
      },
      onSelected: (p) {
        ctrl.text = '${p.codigo} - ${p.nombre}';
        onSelected(p);
      },
      fieldViewBuilder: (context, textCtrl, focus, onFieldSubmitted) {
        textCtrl.value = ctrl.value;
        return TextField(
          controller: textCtrl,
          focusNode: focus,
          decoration: const InputDecoration(hintText: 'Producto'),
        );
      },
    );
  }
}
