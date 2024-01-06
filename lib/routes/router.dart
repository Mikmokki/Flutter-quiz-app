import 'package:go_router/go_router.dart';
import 'package:myproject/screens/main_screen.dart';
import 'package:myproject/screens/question_screen.dart';
import 'package:myproject/screens/statistics_screen.dart';
import 'package:myproject/screens/random_question_screen.dart';

final router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const MainScreen()),
    GoRoute(
        path: '/statistics',
        builder: (context, state) => const StatisticsScreen()),
    GoRoute(
        path: '/topics/:id',
        builder: (context, state) =>
            QuestionScreen(int.parse(state.pathParameters['id']!), null)),
    GoRoute(
        path: '/practice/:id',
        builder: (context, state) =>
            RandomQuestionScreen(int.parse(state.pathParameters['id']!), null))
  ],
);
