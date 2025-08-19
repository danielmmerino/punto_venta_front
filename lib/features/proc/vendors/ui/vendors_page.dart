import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../core/theme/app_spacing.dart';
import '../controllers/vendors_controller.dart';
import '../data/models/vendor.dart';
import 'vendor_detail.dart';
import 'vendor_form.dart';

class VendorsPage extends HookConsumerWidget {
  const VendorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final controller = ref.read(vendorsControllerProvider.notifier);
    final state = ref.watch(vendorsControllerProvider);
    final search = useTextEditingController();
    final timer = useRef<Timer?>(null);

    useEffect(() {
      controller.load();
      void listener() {
        timer.value?.cancel();
        timer.value = Timer(const Duration(milliseconds: 400), () {
          controller.load(params: {'search': search.text});
        });
      }

      search.addListener(listener);
      return () {
        timer.value?.cancel();
        search.removeListener(listener);
      };
    }, []);

    Future<void> openForm([Vendor? vendor]) async {
      final data = await showDialog<Map<String, dynamic>>(
        context: context,
        builder: (_) => VendorForm(initial: vendor),
      );
      if (data != null) {
        if (vendor == null) {
          await controller.create(data);
        } else {
          await controller.update(vendor.id, data);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(spacing.sm),
            child: TextField(
              controller: search,
              decoration: const InputDecoration(hintText: 'Buscar'),
            ),
          ),
          Expanded(
            child: state.isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: state.vendors.length,
                    itemBuilder: (context, index) {
                      final v = state.vendors[index];
                      return ListTile(
                        title: Text(v.razonSocial),
                        subtitle: Text(v.email ?? v.telefono ?? ''),
                        trailing: Text(v.activo ? 'Activo' : 'Inactivo'),
                        onTap: () => showDialog(
                          context: context,
                          builder: (_) => VendorDetail(vendor: v),
                        ),
                        onLongPress: () => openForm(v),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
