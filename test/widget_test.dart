import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/providers/player_provider.dart';

void main() {
  testWidgets('FRAME app launches', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => PlayerProvider(),
        child: const FrameApp(),
      ),
    );

    // Даём время на построение всех виджетов
    await tester.pumpAndSettle();

    // Проверяем, что MaterialApp существует
    expect(find.byType(MaterialApp), findsOneWidget);

    // Проверяем нижнюю навигацию (она точно должна быть)
    expect(find.byType(BottomNavigationBar), findsOneWidget);
  });
}