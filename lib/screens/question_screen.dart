import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/providers/question_providers.dart';
import 'package:myproject/services/topic_service.dart';
import 'package:myproject/util/screen_wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class QuestionScreen extends ConsumerWidget {
  int topic;
  Client? client;
  QuestionScreen(this.topic, this.client, {super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final question = ref.watch(questionProvider(topic));
    final status = ref.watch(statusProvider);
    return question.when(
        loading: () =>
            const ScreenWrapper(Center(child: Text("Retrieving data..."))),
        error: (err, stack) =>
            ScreenWrapper(Center(child: Text("Error: ${err.toString()}"))),
        data: (question) {
          final imageUrl = question.imageUrl;
          return ScreenWrapper(
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                      "Here you can answer questions to increase your score!"),
                  imageUrl != null
                      ? Image(
                          image: NetworkImage(imageUrl),
                        )
                      : Container(),
                  Text(question.question),
                  const SizedBox(height: 16.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: question.options
                        .map(
                          (o) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: status == Status.correct
                                  ? null
                                  : () => _handleOptionSelected(
                                      ref, question.answerPostPath, o),
                              child: Text(o),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16.0),
                  status != Status.waiting
                      ? status == Status.correct
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Correct answer!"),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () =>
                                      fetchNewQuestion(ref, context),
                                  child: const Text("Fetch new question"),
                                ),
                              ],
                            )
                          : const Text("Wrong answer. Try again!")
                      : Container(),
                ],
              ),
            ),
          );
        });
  }

  void _handleOptionSelected(
      WidgetRef ref, postPath, String selectedOption) async {
    bool correct =
        await TopicService(client: client).sendAnswer(postPath, selectedOption);
    if (correct) {
      ref.read(correctAnswerProvider(topic).notifier).state =
          ref.watch(correctAnswerProvider(topic)) + 1;
    }
    ref
        .watch(statusProvider.notifier)
        .update((state) => correct ? Status.correct : Status.incorrect);
  }

  void fetchNewQuestion(WidgetRef ref, BuildContext context) {
    ref.watch(statusProvider.notifier).update((state) => Status.waiting);
    ref.refresh(questionProvider(topic));
  }
}
