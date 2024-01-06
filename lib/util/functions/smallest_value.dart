import 'package:myproject/services/topic_service.dart';

int getSmallestValue(List<(Topic, int)> sortedTopics) {
  int smallestValue = sortedTopics.isNotEmpty ? sortedTopics.last.$2 : 0;
  List<(Topic, int)> smallestValues =
      sortedTopics.where((element) => element.$2 == smallestValue).toList();
  smallestValues.shuffle();
  return smallestValues.last.$1.id;
}
