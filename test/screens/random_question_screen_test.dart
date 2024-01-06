import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/providers/question_providers.dart';
import 'package:myproject/routes/router.dart';
import 'package:myproject/services/topic_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MockSharedPreferences extends Mock implements SharedPreferences {}

final topics = [
  Topic(1, 'Topic 1', '/questions/1'),
  Topic(2, 'Topic 2', '/questions/2'),
];

main() async {
  testWidgets(
      'Choosing the generic practice option and being shown a question from a topic with the fewest correct answers. Verifying that the choice of the topic is done based on data in SharedPreferences and that the question matches the data from the API.',
      (WidgetTester tester) async {
    final mockClient = MockClient((request) async {
      if (request.url.path.contains("/topics/1")) {
        return http.Response(
            jsonEncode({
              "id": 4,
              "question": "What is the outcome of 3 + 3?",
              "options": ["6", "2", "20", "100"],
              "answer_post_path": "/topics/1/questions/4/answers"
            }),
            200);
      } else if (request.url.path.contains("/topics/2")) {
        return http.Response(
            jsonEncode({
              "id": 6,
              "question": "What is the capital of Antigua and Barbuda?",
              "options": ["Luanda", "Vienna", "Tirana", "St. John's"],
              "answer_post_path": "/topics/2/questions/6/answers"
            }),
            200);
      } else {
        return http.Response(
            jsonEncode({
              "id": 1,
              "question": "In what continent is Afghanistan located?",
              "options": ["Europe", "Asia", "Africa"],
              "answer_post_path": "/topics/3/questions/1/answers"
            }),
            200);
      }
    });

    SharedPreferences.setMockInitialValues({"count_1": 5, "count_2": 1});
    SharedPreferences pref = await SharedPreferences.getInstance();
    final app = ProviderScope(overrides: [
      topicsProvider.overrideWithProvider(
          AutoDisposeFutureProvider((ref) => Future.value(topics))),
      sharedPreferencesProvider.overrideWithValue(pref),
      questionProvider.overrideWithProvider(AutoDisposeFutureProvider.family(
          (ref, int topic) async =>
              TopicService(client: mockClient).getQuestion(topic)))
    ], child: MaterialApp.router(routerConfig: router));
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    final genericPractice = find.text('Generic practice');
    expect(genericPractice, findsOneWidget);
    await tester.tap(genericPractice);
    await tester.pumpAndSettle();

    for (var element in [
      "What is the capital of Antigua and Barbuda?",
      "Luanda",
      "Vienna",
      "Tirana",
      "St. John's"
    ]) {
      expect(find.text(element), findsOneWidget);
    }
  });
}
