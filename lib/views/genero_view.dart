import 'package:flutter/material.dart';

import '../util.dart';

class GeneroView extends StatefulWidget {
  const GeneroView({super.key});

  @override
  State<GeneroView> createState() => _GeneroViewState();
}

class _GeneroViewState extends State<GeneroView> {
  final _nombre = TextEditingController();
  Future<Map<String, dynamic>>? _consulta;

  void _predecir() {
    final nombre = _nombre.text.trim();
    if (nombre.isEmpty) return;
    setState(() {
      _consulta = getJson('https://api.genderize.io/?name=${Uri.encodeQueryComponent(nombre)}')
          .then((j) => j as Map<String, dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _nombre,
            decoration: const InputDecoration(labelText: 'Nombre de la persona', border: OutlineInputBorder()),
            onSubmitted: (_) => _predecir(),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _predecir, icon: const Icon(Icons.search), label: const Text('Predecir género')),
          const SizedBox(height: 24),
          if (_consulta != null)
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _consulta,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) return MensajeError(snap.error!);
                  final datos = snap.data!;
                  final genero = datos['gender'];
                  if (genero == null) {
                    return const Center(child: Text('No se pudo predecir el género de ese nombre.'));
                  }
                  final esMasculino = genero == 'male';
                  final color = esMasculino ? Colors.blue : Colors.pink;
                  final probabilidad = ((datos['probability'] as num) * 100).round();
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    width: double.infinity,
                    decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(esMasculino ? Icons.male : Icons.female, size: 120, color: Colors.white),
                        Text(esMasculino ? 'Masculino' : 'Femenino',
                            style: const TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('${datos['name']} · $probabilidad% de probabilidad',
                            style: const TextStyle(color: Colors.white, fontSize: 16)),
                      ],
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
