import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/providers/question_providers.dart';
import 'package:myproject/screens/question_screen.dart';
import 'package:myproject/services/topic_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MockTopicService extends Mock implements TopicService {}

class MockSharedPreferences extends Mock implements SharedPreferences {}

final question = Question(1, "What does the fox say?",
    ["moo", "hola", "who knows?"], "/answerhere", null);
void main() async {
  final mockClient = MockClient((request) async {
    return http.Response(
        jsonEncode({
          "correct": (jsonDecode(request.body)["answer"] == "who knows?"),
        }),
        200);
  });

  final mockSharedPreferences = MockSharedPreferences();
  when(() => mockSharedPreferences.getInt("Topic 1")).thenReturn(1);
  final app = ProviderScope(
    overrides: [
      questionProvider.overrideWithProvider(
        AutoDisposeFutureProvider.family((ref, int i) async => question),
      ),
      sharedPreferencesProvider.overrideWithValue(mockSharedPreferences),
      correctAnswerProvider
          .overrideWithProvider((argument) => StateProvider((ref) => 1))
    ],
    child: MaterialApp(
      home: QuestionScreen(1, mockClient),
    ),
  );
  testWidgets(
      '2. Selecting a topic without images and seeing a question for that topic. Verifying that the question text and the answer options from the API are shown.',
      (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    expect(find.text('What does the fox say?'), findsOneWidget);
    expect(find.text('moo'), findsOneWidget);
    expect(find.text('hola'), findsOneWidget);
    expect(find.text('who knows?'), findsOneWidget);
  });

  testWidgets(
      '3. Selecting an answer option. Verifying that the feedback (correctness or incorrectness) matches the data received from the API.',
      (WidgetTester tester) async {
    await tester.pumpWidget(app);
    await tester.pumpAndSettle();
    var answer = "hola";
    expect(find.text(answer), findsOneWidget);
    await tester.tap(find.text(answer));
    await tester.pumpAndSettle();
    expect(find.text("Wrong answer. Try again!"), findsOneWidget);
    answer = "who knows?";
    expect(find.text(answer), findsOneWidget);
    await tester.tap(find.text(answer));
    await tester.pumpAndSettle();
    expect(find.text("Correct answer!"), findsOneWidget);
  });
}
