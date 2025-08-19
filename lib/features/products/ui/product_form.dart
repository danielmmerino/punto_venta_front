import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../data/models/product.dart';

class ProductForm extends HookConsumerWidget {
  const ProductForm({super.key, this.initial});

  final Product? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final codigoCtrl =
        useTextEditingController(text: initial?.codigo ?? '');
    final nombreCtrl =
        useTextEditingController(text: initial?.nombre ?? '');
    final precioCtrl = useTextEditingController(
        text: initial?.precio.toString() ?? '');
    final activo = useState(initial?.activo ?? true);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(initial == null ? 'Nuevo producto' : 'Editar producto',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: spacing.md),
              TextFormField(
                controller: codigoCtrl,
                decoration: const InputDecoration(labelText: 'Código'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.md),
              TextFormField(
                controller: nombreCtrl,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.md),
              TextFormField(
                controller: precioCtrl,
                decoration: const InputDecoration(labelText: 'Precio'),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                validator: (v) {
                  final value = double.tryParse(v ?? '');
                  if (value == null || value < 0) {
                    return 'Precio inválido';
                  }
                  return null;
                },
              ),
              SizedBox(height: spacing.md),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Activo'),
                value: activo.value,
                onChanged: (v) => activo.value = v,
              ),
              SizedBox(height: spacing.lg),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.of(context).pop({
                        'codigo': codigoCtrl.text,
                        'nombre': nombreCtrl.text,
                        'precio': double.parse(precioCtrl.text),
                        'activo': activo.value,
                      });
                    }
                  },
                  child: const Text('Guardar'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
