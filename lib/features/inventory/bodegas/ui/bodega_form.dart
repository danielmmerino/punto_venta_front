import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../controllers/bodegas_controller.dart';
import '../data/models/bodega.dart';

class BodegaForm extends HookConsumerWidget {
  const BodegaForm({super.key, this.initial});

  final Bodega? initial;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final codigoCtrl =
        useTextEditingController(text: initial?.codigo ?? '');
    final nombreCtrl =
        useTextEditingController(text: initial?.nombre ?? '');
    final zonaCtrl = useTextEditingController(text: initial?.zona ?? '');
    final activo = useState(initial?.activo ?? true);

    final fieldErrors =
        ref.watch(bodegasControllerProvider.select((s) => s.fieldErrors));

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
              Text(initial == null ? 'Nueva bodega' : 'Editar bodega',
                  style: Theme.of(context).textTheme.titleLarge),
              SizedBox(height: spacing.md),
              TextFormField(
                controller: codigoCtrl,
                decoration: InputDecoration(
                  labelText: 'Código',
                  errorText: fieldErrors['codigo']?.first,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.md),
              TextFormField(
                controller: nombreCtrl,
                decoration: InputDecoration(
                  labelText: 'Nombre',
                  errorText: fieldErrors['nombre']?.first,
                ),
                validator: (v) => v == null || v.isEmpty ? 'Requerido' : null,
              ),
              SizedBox(height: spacing.md),
              TextFormField(
                controller: zonaCtrl,
                decoration: const InputDecoration(labelText: 'Zona (opcional)'),
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
                        'zona': zonaCtrl.text.isEmpty ? null : zonaCtrl.text,
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
