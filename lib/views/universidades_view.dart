import 'package:flutter/material.dart';

import '../util.dart';

class UniversidadesView extends StatefulWidget {
  const UniversidadesView({super.key});

  @override
  State<UniversidadesView> createState() => _UniversidadesViewState();
}

class _UniversidadesViewState extends State<UniversidadesView> {
  final _pais = TextEditingController(text: 'Dominican Republic');
  Future<List<dynamic>>? _consulta;

  void _buscar() {
    final pais = _pais.text.trim();
    if (pais.isEmpty) return;
    setState(() {
      _consulta = getJson('https://adamix.net/proxy.php?country=${Uri.encodeQueryComponent(pais)}')
          .then((j) => j as List<dynamic>);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _pais,
            decoration: const InputDecoration(labelText: 'País (en inglés)', border: OutlineInputBorder()),
            onSubmitted: (_) => _buscar(),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: _buscar, icon: const Icon(Icons.search), label: const Text('Buscar universidades')),
          const SizedBox(height: 12),
          if (_consulta != null)
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: _consulta,
                builder: (context, snap) {
                  if (snap.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snap.hasError) return MensajeError(snap.error!);
                  final unis = snap.data!;
                  if (unis.isEmpty) return const Center(child: Text('No se encontraron universidades.'));
                  return ListView.builder(
                    itemCount: unis.length,
                    itemBuilder: (context, i) {
                      final u = unis[i];
                      final dominios = (u['domains'] as List).join(', ');
                      final paginas = (u['web_pages'] as List).cast<String>();
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.school),
                          title: Text(u['name']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Dominio: $dominios'),
                              for (final web in paginas)
                                InkWell(
                                  onTap: () => abrirUrl(web),
                                  child: Text(web,
                                      style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline)),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
