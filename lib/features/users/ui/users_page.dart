import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../controllers/users_controller.dart';

class UsersPage extends HookConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersControllerProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Usuarios')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return ListTile(
                  title: Text('${user.nombres} ${user.apellidos}'),
                  subtitle: Text(user.email),
                );
              },
            ),
    );
  }
}
