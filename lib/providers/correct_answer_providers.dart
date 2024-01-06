import 'package:myproject/services/topic_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final sharedPreferencesProvider =
    Provider<SharedPreferences>((ref) => throw UnimplementedError());

final correctAnswerProvider = StateProvider.family<int, int>((ref, topic) {
  final preferences = ref.watch(sharedPreferencesProvider);
  final key = 'count_$topic';
  final currentValue = preferences.getInt(key) ?? 0;

  ref.listenSelf((prev, curr) {
    preferences.setInt(key, curr);
  });

  return currentValue;
});

List<(Topic, int)> correctAnswerSortedProvider(
    WidgetRef ref, List<Topic> topics) {
  final preferences = ref.watch(sharedPreferencesProvider);
  final counts = topics.map((Topic topic) {
    String key = 'count_${topic.id}';
    int currentValue = preferences.getInt(key) ?? 0;
    return (topic, currentValue);
  }).toList();

  counts.sort((a, b) => -a.$2.compareTo(b.$2));
  return counts;
}
