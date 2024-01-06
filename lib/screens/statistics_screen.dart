import 'package:flutter/material.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/providers/question_providers.dart';
import 'package:myproject/util/screen_wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topics = ref.watch(topicsProvider);
    return topics.when(
      loading: () =>
          const ScreenWrapper(Center(child: Text("Retrieving stats..."))),
      error: (err, stack) =>
          ScreenWrapper(Center(child: Text("Error: ${err.toString()}"))),
      data: (topics) {
        final sortedTopics = correctAnswerSortedProvider(ref, topics);
        return ScreenWrapper(Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Statistics',
                style: TextStyle(
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                'Here you can see your stats from all the topics!',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Text(
                'Total number of correct answers: ${sortedTopics.fold(0, (previousValue, element) => previousValue + element.$2)}',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: sortedTopics.length,
                    itemBuilder: (context, index) {
                      final topic = sortedTopics[index].$1;
                      final likeCount =
                          ref.watch(correctAnswerProvider(topic.id));
                      return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: TextButton(
                              onPressed: null,
                              child: Column(children: [
                                Text(
                                    style: const TextStyle(
                                        fontSize: 24.0, color: Colors.black),
                                    'Topic ${topic.name} Correct answers: $likeCount'),
                              ])));
                    },
                  ))
            ]));
      },
    );
  }
}
