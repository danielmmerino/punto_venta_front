import 'package:flutter/material.dart';

import '../controllers/quote_controller.dart';
import '../data/models/quote.dart';

class QuoteFormPage extends StatefulWidget {
  const QuoteFormPage({super.key});

  @override
  State<QuoteFormPage> createState() => _QuoteFormPageState();
}

class _QuoteFormPageState extends State<QuoteFormPage> {
  late QuoteController controller;

  @override
  void initState() {
    super.initState();
    controller = QuoteController(Quote(clienteId: 0, validezDias: 30));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nueva cotización')),
      body: const Center(child: Text('Formulario de cotización')),
      floatingActionButton: FloatingActionButton(
        onPressed: controller.enviar,
        tooltip: 'Enviar',
        child: const Icon(Icons.send),
      ),
    );
  }
}
