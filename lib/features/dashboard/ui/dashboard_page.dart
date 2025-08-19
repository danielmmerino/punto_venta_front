import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../core/ui/menu_drawer.dart';
import '../controllers/dashboard_controller.dart';
import 'widgets/kpi_card.dart';
import 'widgets/alert_banner.dart';
import 'widgets/product_tile.dart';
import 'package:intl/intl.dart';

class DashboardPage extends HookConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final spacing = Theme.of(context).extension<AppSpacing>()!;
    final state = ref.watch(dashboardControllerProvider);
    final currency = NumberFormat.simpleCurrency();
    useEffect(() {
      Future.microtask(() =>
          ref.read(dashboardControllerProvider.notifier).load());
      return null;
    }, const []);

    Widget content;
    if (state.isLoading && state.ventasTotales == 0 && state.productos.isEmpty) {
      content = const Center(child: CircularProgressIndicator());
    } else if (state.error != null) {
      content = Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(state.error!),
            SizedBox(height: spacing.md),
            ElevatedButton(
              onPressed: () =>
                  ref.read(dashboardControllerProvider.notifier).load(),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    } else {
      content = LayoutBuilder(builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 800;
        final crossAxisCount = isWide ? 4 : 2;
        return RefreshIndicator(
          onRefresh: () =>
              ref.read(dashboardControllerProvider.notifier).load(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(spacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1280),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final alert in state.alertas) ...[
                      AlertBanner(alert: alert),
                      SizedBox(height: spacing.md),
                    ],
                    GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: spacing.md,
                      mainAxisSpacing: spacing.md,
                      children: [
                        KpiCard(
                          title: 'Ventas del día',
                          value: currency.format(state.ventasTotales),
                          subtitle: 'hoy',
                        ),
                        KpiCard(
                          title: 'Ticket promedio',
                          value: currency.format(state.ticketPromedio),
                          subtitle: '${state.tickets} tickets',
                        ),
                      ],
                    ),
                    SizedBox(height: spacing.lg),
                    Text('Top 5 productos',
                        style: Theme.of(context).textTheme.titleMedium),
                    if (state.productos.isEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: spacing.md),
                        child: const Text('Sin ventas registradas hoy'),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.productos.length,
                        itemBuilder: (context, index) {
                          final p = state.productos[index];
                          return ProductTile(producto: p);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      });
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      drawer: const MenuDrawer(),
      body: content,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/ventas/nueva'),
        icon: const Icon(Icons.point_of_sale),
        label: const Text('Nueva venta'),
      ),
    );
  }
}
