import 'package:flutter/material.dart';

import '../../adjust/ui/adjust_page.dart';
import '../../transfer/ui/transfer_page.dart';
import '../../../../core/ui/menu_drawer.dart';

class InventoryMovementsPage extends StatelessWidget {
  const InventoryMovementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Movimientos'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Ajuste'),
              Tab(text: 'Traspaso'),
            ],
          ),
        ),
        drawer: const MenuDrawer(),
        body: const TabBarView(
          children: [
            AdjustPage(),
            TransferPage(),
          ],
        ),
      ),
    );
  }
}
