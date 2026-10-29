import 'package:flutter/material.dart';

class InicioView extends StatelessWidget {
  const InicioView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/caja_herramientas.jpg', fit: BoxFit.cover),
            ),
            const SizedBox(height: 24),
            Text('Caja de Herramientas', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 8),
            const Text(
              'Una aplicación que sirve para varias cosas. Abre el menú lateral para elegir una herramienta.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
