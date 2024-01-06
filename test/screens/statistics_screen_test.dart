import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/providers/question_providers.dart';
import 'package:myproject/screens/statistics_screen.dart';
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
    child: const MaterialApp(home: StatisticsScreen()),
  );
  testWidgets(
      '4. Opening the statistics page and seeing the total correct answer count. Verifying that the correct answer count matches data stored in SharedPreferences.',
      (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text("Total number of correct answers: 6"), findsOne);
  });
  testWidgets(
      '5. Opening the statistics page and seeing the total correct answer count. Verifying that the correct answer count matches data stored in SharedPreferences.',
      (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text('Topic Topic 1 Correct answers: 5'), findsOne);
    expect(find.text('Topic Topic 2 Correct answers: 1'), findsOne);
  });
}
