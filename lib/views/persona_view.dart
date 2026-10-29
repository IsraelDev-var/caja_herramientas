import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util.dart';

class PersonaView extends StatefulWidget {
  const PersonaView({super.key});

  @override
  State<PersonaView> createState() => _PersonaViewState();
}

class _PersonaViewState extends State<PersonaView> {
  late Future<Map<String, dynamic>> _persona;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    _persona = getJson('https://randomuser.me/api/?results=1')
        .then((j) => (j['results'] as List).first as Map<String, dynamic>);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _persona,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) return Center(child: MensajeError(snap.error!));
        final p = snap.data!;
        final nacimiento = DateTime.parse(p['dob']['date']).toLocal();
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                CircleAvatar(radius: 80, backgroundImage: NetworkImage(p['picture']['large'])),
                const SizedBox(height: 24),
                _Dato('Nombre', p['name']['first']),
                _Dato('Apellido', p['name']['last']),
                _Dato('Fecha de nacimiento', DateFormat('dd/MM/yyyy').format(nacimiento)),
                _Dato('Edad', '${p['dob']['age']} años'),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => setState(_cargar),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Otra persona'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Dato extends StatelessWidget {
  final String etiqueta;
  final String valor;
  const _Dato(this.etiqueta, this.valor);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(title: Text(valor, style: const TextStyle(fontSize: 18)), subtitle: Text(etiqueta)),
    );
  }
}
