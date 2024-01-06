import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/providers/question_providers.dart';
import 'package:myproject/screens/main_screen.dart';
import 'package:myproject/services/topic_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

final topics = [
  Topic(1, 'Topic 1', '/questions/1'),
  Topic(2, 'Topic 2', '/questions/2'),
];
Future<void> main() async {
  SharedPreferences.setMockInitialValues({"count_1": 5, "count_2": 1});
  SharedPreferences pref = await SharedPreferences.getInstance();
  final app = ProviderScope(
    overrides: [
      topicsProvider.overrideWithProvider(
          AutoDisposeFutureProvider((ref) => Future.value(topics))),
      sharedPreferencesProvider.overrideWithValue(pref),
    ],
    child: const MaterialApp(home: MainScreen()),
  );
  testWidgets(
      '1. Opening the application and seeing the list of topics. Verifying that the topics from the API are shown.',
      (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text('Topic 1'), findsOneWidget);
    expect(find.text('Topic 2'), findsOneWidget);
    expect(find.text('Generic practice'), findsOneWidget);
  });
}
