import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../controllers/login_controller.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final emailController =
        useTextEditingController(text: 'mesero@demo.com');
    final passwordController =
        useTextEditingController(text: 'VendePro#2025');
    final obscure = useState(true);
    final state = ref.watch(loginControllerProvider);

    return Scaffold(
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
                      Text('Iniciar sesión',
                          style: Theme.of(context).textTheme.titleLarge),
                      SizedBox(height: spacing.lg),
                      if (state.error != null) ...[
                        Container(
                          padding: EdgeInsets.all(spacing.sm),
                          decoration: BoxDecoration(
                            color: colors.error,
                            borderRadius:
                                BorderRadius.circular(radius.sm),
                          ),
                          child: Text(
                            state.error!,
                            style: TextStyle(color: colors.n0),
                          ),
                        ),
                        SizedBox(height: spacing.md),
                      ],
                      TextFormField(
                        controller: emailController,
                        enabled: !state.isLoading,
                        decoration:
                            const InputDecoration(labelText: 'Email'),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final email = value ?? '';
                          final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                          if (!regex.hasMatch(email)) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: spacing.md),
                      TextFormField(
                        controller: passwordController,
                        enabled: !state.isLoading,
                        obscureText: obscure.value,
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          suffixIcon: IconButton(
                            onPressed: () =>
                                obscure.value = !obscure.value,
                            icon: Icon(obscure.value
                                ? Icons.visibility_off
                                : Icons.visibility),
                          ),
                        ),
                        validator: (value) {
                          final pass = value ?? '';
                          if (pass.length < 8) {
                            return 'Mínimo 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: spacing.lg),
                      Semantics(
                        button: true,
                        child: ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () async {
                                  if (formKey.currentState!.validate()) {
                                    await ref
                                        .read(loginControllerProvider
                                            .notifier)
                                        .submit(emailController.text,
                                            passwordController.text);
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
                              : const Text('Ingresar'),
                        ),
                      ),
                      SizedBox(height: spacing.md),
                      TextButton(
                        onPressed: state.isLoading ? null : () {},
                        child: const Text('¿Olvidaste tu contraseña?'),
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
