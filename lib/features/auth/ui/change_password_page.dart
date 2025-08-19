import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordPage extends HookConsumerWidget {
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final currentController = useTextEditingController();
    final newController = useTextEditingController();
    final confirmController = useTextEditingController();
    final obscureCurrent = useState(true);
    final obscureNew = useState(true);
    final obscureConfirm = useState(true);
    final state = ref.watch(changePasswordControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar contraseña')),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius.lg),
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text('Actualizar contraseña',
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: spacing.lg),
                      if (state.error != null) ...[
                        Container(
                          padding: EdgeInsets.all(spacing.sm),
                          decoration: BoxDecoration(
                            color: colors.error,
                            borderRadius: BorderRadius.circular(radius.sm),
                          ),
                          child: Text(
                            state.error!,
                            style: TextStyle(color: colors.n0),
                          ),
                        ),
                        SizedBox(height: spacing.md),
                      ],
                      if (state.success) ...[
                        Container(
                          padding: EdgeInsets.all(spacing.sm),
                          decoration: BoxDecoration(
                            color: colors.success,
                            borderRadius: BorderRadius.circular(radius.sm),
                          ),
                          child: Text(
                            'Contraseña actualizada',
                            style: TextStyle(color: colors.n0),
                          ),
                        ),
                        SizedBox(height: spacing.md),
                      ],
                      TextFormField(
                        controller: currentController,
                        obscureText: obscureCurrent.value,
                        enabled: !state.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Contraseña actual',
                          suffixIcon: IconButton(
                            onPressed: () =>
                                obscureCurrent.value = !obscureCurrent.value,
                            icon: Icon(obscureCurrent.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        validator: (v) => (v == null || v.isEmpty)
                            ? 'Ingresa tu contraseña actual'
                            : null,
                      ),
                      SizedBox(height: spacing.md),
                      TextFormField(
                        controller: newController,
                        obscureText: obscureNew.value,
                        enabled: !state.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Nueva contraseña',
                          suffixIcon: IconButton(
                            onPressed: () =>
                                obscureNew.value = !obscureNew.value,
                            icon: Icon(obscureNew.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        validator: (v) {
                          final pass = v ?? '';
                          if (pass.length < 8) {
                            return 'Mínimo 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: spacing.md),
                      TextFormField(
                        controller: confirmController,
                        obscureText: obscureConfirm.value,
                        enabled: !state.isLoading,
                        decoration: InputDecoration(
                          labelText: 'Confirmar contraseña',
                          suffixIcon: IconButton(
                            onPressed: () => obscureConfirm.value =
                                !obscureConfirm.value,
                            icon: Icon(obscureConfirm.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        validator: (v) {
                          if (v != newController.text) {
                            return 'Las contraseñas no coinciden';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: spacing.lg),
                      ElevatedButton(
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                if (formKey.currentState!.validate()) {
                                  await ref
                                      .read(changePasswordControllerProvider
                                          .notifier)
                                      .submit(currentController.text,
                                          newController.text);
                                }
                              },
                        child: state.isLoading
                            ? SizedBox(
                                width: spacing.lg,
                                height: spacing.lg,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Guardar'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
