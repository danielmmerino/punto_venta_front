import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_colors.dart';

class KpiCard extends StatelessWidget {
  const KpiCard({super.key, required this.title, required this.value, this.subtitle});

  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final radius = Theme.of(context).extension<AppRadius>()!;
    final colors = Theme.of(context).extension<AppColors>()!;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius.md),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: spacing.sm),
            Text(value, style: Theme.of(context).textTheme.headlineSmall),
            if (subtitle != null) ...[
              SizedBox(height: spacing.xs),
              Text(subtitle!,
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium
                      ?.copyWith(color: colors.n600)),
            ],
          ],
        ),
      ),
    );
  }
}
