import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../data/models/vendor.dart';

class VendorForm extends StatefulWidget {
  const VendorForm({super.key, this.initial});

  final Vendor? initial;

  @override
  State<VendorForm> createState() => _VendorFormState();
}

class _VendorFormState extends State<VendorForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _ruc;
  late final TextEditingController _razon;
  late final TextEditingController _email;
  late final TextEditingController _telefono;
  late final TextEditingController _direccion;
  late bool _activo;

  @override
  void initState() {
    super.initState();
    final v = widget.initial;
    _ruc = TextEditingController(text: v?.ruc);
    _razon = TextEditingController(text: v?.razonSocial);
    _email = TextEditingController(text: v?.email);
    _telefono = TextEditingController(text: v?.telefono);
    _direccion = TextEditingController(text: v?.direccion);
    _activo = v?.activo ?? true;
  }

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return AlertDialog(
      title: Text(widget.initial == null ? 'Nuevo proveedor' : 'Editar proveedor'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _ruc,
                decoration: const InputDecoration(labelText: 'RUC'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.sm),
              TextFormField(
                controller: _razon,
                decoration: const InputDecoration(labelText: 'Razón social'),
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
                'ruc': _ruc.text,
                'razon_social': _razon.text,
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
