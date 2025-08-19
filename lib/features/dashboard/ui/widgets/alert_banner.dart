import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../controllers/dashboard_controller.dart';

class AlertBanner extends StatelessWidget {
  const AlertBanner({super.key, required this.alert});

  final DashboardAlert alert;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    Color bg;
    IconData icon;
    switch (alert.type) {
      case AlertType.error:
        bg = colors.error;
        icon = Icons.error;
        break;
      case AlertType.warning:
        bg = colors.warning;
        icon = Icons.warning;
        break;
    }
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(spacing.md),
      decoration: BoxDecoration(
        color: bg,
      ),
      child: Row(
        children: [
          Icon(icon, color: colors.n0),
          SizedBox(width: spacing.sm),
          Expanded(
            child: Text(alert.message,
                style: TextStyle(color: colors.n0)),
          ),
        ],
      ),
    );
  }
}
