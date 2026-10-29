import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

/// GET a una URL y devuelve el JSON decodificado.
Future<dynamic> getJson(String url) async {
  final res = await http.get(Uri.parse(url));
  if (res.statusCode != 200) {
    throw Exception('Error ${res.statusCode} al consultar el servicio');
  }
  return jsonDecode(utf8.decode(res.bodyBytes));
}

Future<void> abrirUrl(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

/// Quita etiquetas HTML y entidades comunes (para títulos y resúmenes de WordPress).
String limpiarHtml(String html) {
  return html
      .replaceAll(RegExp(r'<[^>]*>'), '')
      .replaceAll('&nbsp;', ' ')
      .replaceAll('&amp;', '&')
      .replaceAll('&#8217;', '’')
      .replaceAll('&#8216;', '‘')
      .replaceAll('&#8220;', '“')
      .replaceAll('&#8221;', '”')
      .replaceAll('&#8211;', '–')
      .replaceAll('&#8230;', '…')
      .replaceAll('[&hellip;]', '…')
      .replaceAll('&hellip;', '…')
      .trim();
}

class MensajeError extends StatelessWidget {
  final Object error;
  const MensajeError(this.error, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text('Ocurrió un error: $error',
          style: TextStyle(color: Theme.of(context).colorScheme.error), textAlign: TextAlign.center),
    );
  }
}
