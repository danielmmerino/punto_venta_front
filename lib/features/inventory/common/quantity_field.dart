import 'package:flutter/material.dart';

class QuantityField extends StatelessWidget {
  const QuantityField({
    super.key,
    required this.value,
    required this.onChanged,
    this.allowNegative = false,
  });

  final double value;
  final ValueChanged<double> onChanged;
  final bool allowNegative;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value == 0 ? '' : value.toString(),
      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
      decoration: const InputDecoration(hintText: 'Cantidad'),
      onChanged: (v) {
        final parsed = double.tryParse(v) ?? 0;
        if (!allowNegative && parsed < 0) {
          onChanged(0);
        } else {
          onChanged(parsed);
        }
      },
    );
  }
}
