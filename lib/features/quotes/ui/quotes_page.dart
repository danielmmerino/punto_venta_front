import 'package:flutter/material.dart';

import '../data/models/quote.dart';

class QuotesPage extends StatefulWidget {
  const QuotesPage({super.key});

  @override
  State<QuotesPage> createState() => _QuotesPageState();
}

class _QuotesPageState extends State<QuotesPage> {
  final _searchCtrl = TextEditingController();
  QuoteStatus? _status;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cotizaciones')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(labelText: 'Buscar'),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<QuoteStatus?>(
                  value: _status,
                  hint: const Text('Estado'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Todos')),
                    ...QuoteStatus.values.map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name),
                      ),
                    )
                  ],
                  onChanged: (v) => setState(() => _status = v),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(child: Text('Sin resultados')),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Nueva cotización',
        child: const Icon(Icons.add),
      ),
    );
  }
}
