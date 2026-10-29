import 'package:flutter_test/flutter_test.dart';

import 'package:caja_herramientas/main.dart';

void main() {
  testWidgets('La pantalla de inicio muestra la caja de herramientas', (tester) async {
    await tester.pumpWidget(const CajaHerramientasApp());
    expect(find.text('Caja de Herramientas'), findsWidgets);
  });
}
