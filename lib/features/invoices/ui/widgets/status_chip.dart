import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';

/// Chip that displays the current SRI status of the invoice.
class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.estado});

  final String estado;

  Color _color(AppColors colors) {
    switch (estado) {
      case 'autorizada':
        return colors.success;
      case 'rechazada':
        return colors.error;
      case 'enviada':
        return colors.info;
      default:
        return colors.n500;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    final bg = _color(colors).withOpacity(0.1);
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: spacing.sm, vertical: spacing.xs),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(radius.pill),
      ),
      child: Text(
        estado,
        style: TextStyle(color: _color(colors)),
      ),
    );
  }
}
