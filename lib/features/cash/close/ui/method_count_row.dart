import 'package:flutter/material.dart';

import '../../common/cash_repository.dart';

class MethodCountRow extends StatelessWidget {
  const MethodCountRow(
      {super.key, required this.method, required this.onChanged});

  final MethodCount method;
  final void Function(double) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(method.nombre)),
          SizedBox(
              width: 80,
              child: Text(method.esperado.toStringAsFixed(2),
                  textAlign: TextAlign.right)),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: TextField(
              key: ValueKey('input-${method.metodoId}'),
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              onChanged: (v) =>
                  onChanged(double.tryParse(v.replaceAll(',', '.')) ?? 0),
              decoration: const InputDecoration(
                isDense: true,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              method.diferencia.toStringAsFixed(2),
              textAlign: TextAlign.right,
              style: TextStyle(
                  color: method.diferencia == 0
                      ? Colors.grey
                      : method.diferencia > 0
                          ? Colors.green
                          : Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
