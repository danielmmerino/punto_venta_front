import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../data/auth/auth_repository.dart';

/// Drawer used across the app to navigate between available screens.
class MenuDrawer extends ConsumerWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Menú')),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            onTap: () => context.go('/dashboard'),
          ),
          ListTile(
            leading: const Icon(Icons.inventory),
            title: const Text('Inventario'),
            onTap: () => context.go('/inventario'),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz),
            title: const Text('Movimientos'),
            onTap: () => context.go('/inventario/movimientos'),
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Tomar pedido'),
            onTap: () => context.go('/pedidos/nuevo'),
          ),
          ListTile(
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Productos'),
            onTap: () => context.go('/productos'),
          ),
          ListTile(
            leading: const Icon(Icons.lock),
            title: const Text('Cambiar contraseña'),
            onTap: () {
              Navigator.pop(context);
              context.go('/change-password');
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              Navigator.pop(context);
              await ref.read(authStateProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
    );
  }
}
