import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../controllers/context_controller.dart';
import '../data/local.dart';

class ContextSelectorPage extends HookConsumerWidget {
  const ContextSelectorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    final colors = Theme.of(context).extension<AppColors>()!;
    final controller = ref.read(contextControllerProvider.notifier);
    final state = ref.watch(contextControllerProvider);

    useEffect(() {
      controller.loadContext();
      return null;
    }, const []);

    Widget body;
    if (state.isLoading) {
      body = const Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      body = Center(child: Text(state.error!));
    } else if (state.locales.isEmpty) {
      body = Center(child: Text('No tienes locales asignados'));
    } else {
      body = LayoutBuilder(
        builder: (context, constraints) {
          return GridView.builder(
            padding: EdgeInsets.all(spacing.md),
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 420,
              mainAxisSpacing: spacing.md,
              crossAxisSpacing: spacing.md,
              childAspectRatio: 3,
            ),
            itemCount: state.locales.length,
            itemBuilder: (context, index) {
              final local = state.locales[index];
              return _LocalCard(
                local: local,
                onTap: () => controller.selectLocal(local.id),
                spacing: spacing,
                radius: radius,
                colors: colors,
              );
            },
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Selecciona tu local')),
      body: body,
    );
  }
}

class _LocalCard extends StatelessWidget {
  const _LocalCard({
    required this.local,
    required this.onTap,
    required this.spacing,
    required this.radius,
    required this.colors,
  });

  final Local local;
  final VoidCallback onTap;
  final AppSpacing spacing;
  final AppRadius radius;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: Key('local-${local.id}'),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(radius.md),
        child: Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(local.nombre,
                  style: Theme.of(context).textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}
