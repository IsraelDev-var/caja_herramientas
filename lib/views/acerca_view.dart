import 'package:flutter/material.dart';

import '../util.dart';

const _nombre = 'Israel Vargas Castro';
const _perfil = 'Desarrollador de software · Estudiante ITLA';
const _matricula = '2023-1861';
const _correo = '20231861@itla.edu.do';
const _github = 'https://github.com/IsraelDev-var';
const _linkedin = 'https://www.linkedin.com/in/israel-vargas-castro-09911a251/';

class AcercaView extends StatelessWidget {
  const AcercaView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const CircleAvatar(radius: 90, backgroundImage: AssetImage('assets/images/mi_foto.png')),
            const SizedBox(height: 16),
            Text(_nombre, style: Theme.of(context).textTheme.headlineSmall),
            const Text(_perfil),
            const Text('Matrícula: $_matricula'),
            const SizedBox(height: 8),
            const Text('Disponible para trabajos y proyectos freelance.'),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text(_correo),
                    onTap: () => abrirUrl('mailto:$_correo'),
                  ),
                  ListTile(leading: const Icon(Icons.code), title: const Text('GitHub'), onTap: () => abrirUrl(_github)),
                  ListTile(
                    leading: const Icon(Icons.work),
                    title: const Text('LinkedIn'),
                    onTap: () => abrirUrl(_linkedin),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
