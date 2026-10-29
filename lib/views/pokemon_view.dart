import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

import '../util.dart';

class PokemonView extends StatefulWidget {
  const PokemonView({super.key});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final _nombre = TextEditingController(text: 'pikachu');
  final _reproductor = AudioPlayer();
  Future<Map<String, dynamic>>? _consulta;

  void _buscar() {
    final nombre = _nombre.text.trim().toLowerCase();
    if (nombre.isEmpty) return;
    setState(() {
      _consulta = getJson('https://pokeapi.co/api/v2/pokemon/${Uri.encodeComponent(nombre)}')
          .then((j) => j as Map<String, dynamic>);
    });
  }

  @override
  void dispose() {
    _reproductor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _nombre,
            decoration: const InputDecoration(labelText: 'Nombre del Pokémon', border: OutlineInputBorder()),
            onSubmitted: (_) => _buscar(),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _buscar, icon: const Icon(Icons.search), label: const Text('Buscar')),
          if (_consulta != null)
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: _consulta,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) return const MensajeError('No se encontró ese Pokémon.');
                  final p = snap.data!;
                  final foto = p['sprites']['other']['official-artwork']['front_default'] ??
                      p['sprites']['front_default'];
                  final habilidades = (p['abilities'] as List).map((a) => a['ability']['name'] as String);
                  final sonido = p['cries']?['latest'] as String?;
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        if (foto != null) Image.network(foto, height: 240),
                        Text(p['name'].toString().toUpperCase(), style: Theme.of(context).textTheme.headlineMedium),
                        const SizedBox(height: 8),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.star),
                            title: Text('${p['base_experience'] ?? 'N/D'}'),
                            subtitle: const Text('Experiencia base'),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            leading: const Icon(Icons.bolt),
                            title: Wrap(
                              spacing: 6,
                              runSpacing: 6,
                              children: [for (final h in habilidades) Chip(label: Text(h))],
                            ),
                            subtitle: const Text('Habilidades'),
                          ),
                        ),
                        if (sonido != null)
                          FilledButton.icon(
                            onPressed: () => _reproductor.play(UrlSource(sonido)),
                            icon: const Icon(Icons.volume_up),
                            label: const Text('Escuchar sonido'),
                          ),
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
