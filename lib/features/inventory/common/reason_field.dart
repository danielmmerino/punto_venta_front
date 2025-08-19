import 'package:flutter/material.dart';

class ReasonField extends StatelessWidget {
  const ReasonField({super.key, required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 3,
      decoration: const InputDecoration(
        labelText: 'Motivo',
      ),
    );
  }
}
