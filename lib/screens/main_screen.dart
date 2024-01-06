import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/providers/question_providers.dart';
import 'package:myproject/services/topic_service.dart';
import 'package:myproject/util/functions/smallest_value.dart';
import 'package:myproject/util/screen_wrapper.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicsProvider);
    const helpTexts = [
      Text(
          "Welcome to quiz app! Here you can answer questions on different topics and also train your weakest topics in generic practice!"),
      Text("Check also your stats on statistics page!")
    ];
    return topics.when(
        loading: () => const ScreenWrapper(Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [...helpTexts, Text("Retrieving data...")]))),
        error: (err, stack) => ScreenWrapper(Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [...helpTexts, Text("Error: $err")]))),
        data: (topics) {
          if (topics.isEmpty) {
            return const ScreenWrapper(
                Center(child: Text("No topics available")));
          }
          final sortedTopics = correctAnswerSortedProvider(ref, topics);

          return ScreenWrapper(
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            ...helpTexts,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  Topic topic = topics[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: TextButton(
                      onPressed: () => context.go("/topics/${topic.id}"),
                      child: Text(
                        topic.name,
                        style: const TextStyle(fontSize: 18.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            TextButton(
              onPressed: () =>
                  context.go("/practice/${getSmallestValue(sortedTopics)}"),
              child: const Text(
                "Generic practice",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ]));
        });
  }
}
