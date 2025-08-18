import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

class AuthBlockedPage extends StatelessWidget {
  const AuthBlockedPage({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: const Text('Autenticación requerida'),
        ),
      ),
    );
  }
}
