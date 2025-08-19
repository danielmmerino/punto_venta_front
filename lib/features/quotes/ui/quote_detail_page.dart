import 'package:flutter/material.dart';

import '../controllers/quote_controller.dart';
import '../data/models/quote.dart';

class QuoteDetailPage extends StatefulWidget {
  const QuoteDetailPage({super.key, required this.controller});

  final QuoteController controller;

  @override
  State<QuoteDetailPage> createState() => _QuoteDetailPageState();
}

class _QuoteDetailPageState extends State<QuoteDetailPage> {
  @override
  Widget build(BuildContext context) {
    final estado = widget.controller.quote.estado;
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de cotización')),
      body: Center(child: Text('Estado: ${estado.name}')),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: estado == QuoteStatus.draft
                  ? () {
                      setState(widget.controller.enviar);
                    }
                  : null,
              child: const Text('Enviar'),
            ),
            ElevatedButton(
              onPressed: estado == QuoteStatus.sent
                  ? () {
                      setState(widget.controller.aceptar);
                    }
                  : null,
              child: const Text('Aceptar'),
            ),
            ElevatedButton(
              onPressed: estado == QuoteStatus.sent
                  ? () {
                      setState(widget.controller.rechazar);
                    }
                  : null,
              child: const Text('Rechazar'),
            ),
            ElevatedButton(
              onPressed: estado == QuoteStatus.accepted
                  ? () {
                      setState(() {
                        widget.controller.facturar();
                      });
                    }
                  : null,
              child: const Text('Facturar'),
            ),
          ],
        ),
      ),
    );
  }
}
