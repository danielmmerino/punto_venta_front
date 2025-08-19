import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Drawer used across the app to navigate between available screens.
class MenuDrawer extends StatelessWidget {
  const MenuDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            leading: const Icon(Icons.shopping_cart),
            title: const Text('Productos'),
            onTap: () => context.go('/productos'),
          ),
        ],
      ),
    );
  }
}
