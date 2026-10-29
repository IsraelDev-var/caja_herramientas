import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util.dart';

/// Clima de hoy en Santo Domingo usando Open-Meteo (no requiere API key).
class ClimaView extends StatefulWidget {
  const ClimaView({super.key});

  @override
  State<ClimaView> createState() => _ClimaViewState();
}

class _ClimaViewState extends State<ClimaView> {
  late final Future<Map<String, dynamic>> _clima = getJson(
    'https://api.open-meteo.com/v1/forecast?latitude=18.4861&longitude=-69.9312'
    '&current=temperature_2m,relative_humidity_2m,wind_speed_10m,weather_code'
    '&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max'
    '&timezone=America/Santo_Domingo&forecast_days=1',
  ).then((j) => j as Map<String, dynamic>);

  static (String, IconData) _describir(int codigo) {
    if (codigo == 0) return ('Despejado', Icons.wb_sunny);
    if (codigo <= 2) return ('Parcialmente nublado', Icons.wb_cloudy);
    if (codigo == 3) return ('Nublado', Icons.cloud);
    if (codigo <= 48) return ('Niebla', Icons.foggy);
    if (codigo <= 57) return ('Llovizna', Icons.grain);
    if (codigo <= 67) return ('Lluvia', Icons.umbrella);
    if (codigo <= 77) return ('Nieve', Icons.ac_unit);
    if (codigo <= 82) return ('Aguaceros', Icons.umbrella);
    return ('Tormenta eléctrica', Icons.thunderstorm);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _clima,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) return Center(child: MensajeError(snap.error!));
        final actual = snap.data!['current'];
        final diario = snap.data!['daily'];
        final (descripcion, icono) = _describir(diario['weather_code'][0]);
        final hoy = DateFormat('dd/MM/yyyy').format(DateTime.now());
        return Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text('Santo Domingo, RD', style: Theme.of(context).textTheme.headlineSmall),
                Text('Hoy, $hoy'),
                const SizedBox(height: 16),
                Icon(icono, size: 120, color: Colors.orange),
                Text(descripcion, style: Theme.of(context).textTheme.headlineMedium),
                Text('${actual['temperature_2m']} °C ahora', style: Theme.of(context).textTheme.displaySmall),
                const SizedBox(height: 24),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _Tarjeta(Icons.arrow_upward, 'Máxima', '${diario['temperature_2m_max'][0]} °C'),
                    _Tarjeta(Icons.arrow_downward, 'Mínima', '${diario['temperature_2m_min'][0]} °C'),
                    _Tarjeta(Icons.water_drop, 'Prob. lluvia', '${diario['precipitation_probability_max'][0]} %'),
                    _Tarjeta(Icons.opacity, 'Humedad', '${actual['relative_humidity_2m']} %'),
                    _Tarjeta(Icons.air, 'Viento', '${actual['wind_speed_10m']} km/h'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Tarjeta extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  const _Tarjeta(this.icono, this.etiqueta, this.valor);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [Icon(icono), Text(etiqueta), Text(valor, style: const TextStyle(fontSize: 18))]),
        ),
      ),
    );
  }
}
