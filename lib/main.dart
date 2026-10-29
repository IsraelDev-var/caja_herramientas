import 'package:flutter/material.dart';

import 'views/inicio_view.dart';
import 'views/genero_view.dart';
import 'views/persona_view.dart';
import 'views/universidades_view.dart';
import 'views/clima_view.dart';
import 'views/pokemon_view.dart';
import 'views/wordpress_view.dart';
import 'views/acerca_view.dart';

void main() => runApp(const CajaHerramientasApp());

class CajaHerramientasApp extends StatelessWidget {
  const CajaHerramientasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caja de Herramientas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.deepOrange, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class Seccion {
  final String titulo;
  final IconData icono;
  final Widget vista;
  const Seccion(this.titulo, this.icono, this.vista);
}

const secciones = <Seccion>[
  Seccion('Inicio', Icons.home_repair_service, InicioView()),
  Seccion('Predecir género', Icons.wc, GeneroView()),
  Seccion('Persona aleatoria', Icons.person_search, PersonaView()),
  Seccion('Universidades', Icons.school, UniversidadesView()),
  Seccion('Clima en RD', Icons.wb_sunny, ClimaView()),
  Seccion('Pokémon', Icons.catching_pokemon, PokemonView()),
  Seccion('Noticias WordPress', Icons.newspaper, WordPressView()),
  Seccion('Acerca de', Icons.info, AcercaView()),
];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _actual = 0;

  @override
  Widget build(BuildContext context) {
    final seccion = secciones[_actual];
    return Scaffold(
      appBar: AppBar(title: Text(seccion.titulo)),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text('Caja de Herramientas',
                    style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ),
            ),
            for (var i = 0; i < secciones.length; i++)
              ListTile(
                leading: Icon(secciones[i].icono),
                title: Text(secciones[i].titulo),
                selected: i == _actual,
                onTap: () {
                  setState(() => _actual = i);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
      body: seccion.vista,
    );
  }
}
