import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../data/models/customer.dart';

class CustomerForm extends StatefulWidget {
  const CustomerForm({super.key, this.initial});

  final Customer? initial;

  @override
  State<CustomerForm> createState() => _CustomerFormState();
}

class _CustomerFormState extends State<CustomerForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _tipo;
  late final TextEditingController _identificacion;
  late final TextEditingController _nombre;
  late final TextEditingController _email;
  late final TextEditingController _telefono;
  late final TextEditingController _direccion;
  late bool _activo;

  @override
  void initState() {
    super.initState();
    final c = widget.initial;
    _tipo = TextEditingController(text: c?.tipo ?? 'PN');
    _identificacion = TextEditingController(text: c?.identificacion);
    _nombre = TextEditingController(text: c?.nombreRazon);
    _email = TextEditingController(text: c?.email);
    _telefono = TextEditingController(text: c?.telefono);
    _direccion = TextEditingController(text: c?.direccion);
    _activo = c?.activo ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return AlertDialog(
      title: Text(widget.initial == null ? 'Nuevo cliente' : 'Editar cliente'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _tipo,
                decoration: const InputDecoration(labelText: 'Tipo'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.sm),
              TextFormField(
                controller: _identificacion,
                decoration: const InputDecoration(labelText: 'Identificación'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.sm),
              TextFormField(
                controller: _nombre,
                decoration: const InputDecoration(labelText: 'Nombre/Razón'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.sm),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (v) {
                  if (v == null || v.isEmpty) return null;
                  final emailReg =
                      RegExp(r'^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$');
                  if (!emailReg.hasMatch(v)) return 'Email inválido';
                  return null;
                },
              ),
              SizedBox(height: spacing.sm),
              TextFormField(
                controller: _telefono,
                decoration: const InputDecoration(labelText: 'Teléfono'),
              ),
              SizedBox(height: spacing.sm),
              TextFormField(
                controller: _direccion,
                decoration: const InputDecoration(labelText: 'Dirección'),
              ),
              SizedBox(height: spacing.sm),
              SwitchListTile(
                value: _activo,
                onChanged: (v) => setState(() => _activo = v),
                title: const Text('Activo'),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context, {
                'tipo': _tipo.text,
                'identificacion': _identificacion.text,
                'nombre_razon': _nombre.text,
                'email': _email.text,
                'telefono': _telefono.text,
                'direccion': _direccion.text,
                'activo': _activo,
              });
            }
          },
          child: const Text('Guardar'),
        ),
      ],
    );
  }
}
