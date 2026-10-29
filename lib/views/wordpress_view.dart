import 'package:flutter/material.dart';

import '../util.dart';

/// Últimas 3 noticias del blog oficial de WordPress (hecho con WordPress).
/// API usada: https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3
class WordPressView extends StatefulWidget {
  const WordPressView({super.key});

  static const api = 'https://wordpress.org/news/wp-json/wp/v2/posts?per_page=3&_fields=title,excerpt,link,date';

  @override
  State<WordPressView> createState() => _WordPressViewState();
}

class _WordPressViewState extends State<WordPressView> {
  late final Future<List<dynamic>> _noticias = getJson(WordPressView.api).then((j) => j as List<dynamic>);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(child: Image.asset('assets/images/wordpress_logo.png', height: 100)),
        const SizedBox(height: 8),
        Center(child: Text('WordPress.org News', style: Theme.of(context).textTheme.titleLarge)),
        const SizedBox(height: 16),
        FutureBuilder<List<dynamic>>(
          future: _noticias,
          builder: (context, snap) {
            if (snap.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) return MensajeError(snap.error!);
            return Column(
              children: [
                for (final n in snap.data!)
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(limpiarHtml(n['title']['rendered']), style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text(limpiarHtml(n['excerpt']['rendered']), maxLines: 5, overflow: TextOverflow.ellipsis),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => abrirUrl(n['link']),
                              icon: const Icon(Icons.open_in_new),
                              label: const Text('Visitar'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ],
    );
  }
}
