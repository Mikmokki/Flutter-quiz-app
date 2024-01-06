import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/services/topic_service.dart';

final questionProvider =
    FutureProvider.family.autoDispose<Question, int>((re, topic) async {
  return TopicService().getQuestion(topic);
});
final topicsProvider = FutureProvider.autoDispose<List<Topic>>((re) async {
  return TopicService().getTopics();
});

enum Status { correct, incorrect, waiting }

final statusProvider =
    StateProvider.autoDispose<Status>((ref) => Status.waiting);
