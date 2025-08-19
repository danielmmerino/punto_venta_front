import 'package:flutter/material.dart';

import '../bodegas/ui/bodegas_page.dart';
import '../stock/ui/stock_page.dart';
import '../../../core/ui/menu_drawer.dart';

class InventoryPage extends StatelessWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inventario'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Bodegas'),
              Tab(text: 'Stock'),
            ],
          ),
        ),
        drawer: const MenuDrawer(),
        body: const TabBarView(
          children: [
            BodegasPage(),
            StockPage(),
          ],
        ),
      ),
    );
  }
}
