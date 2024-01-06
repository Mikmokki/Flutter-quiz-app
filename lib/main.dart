import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/providers/correct_answer_providers.dart';
import 'package:myproject/routes/router.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() async {
  final prefs = await SharedPreferences.getInstance();
  runApp(ProviderScope(
    overrides: [
      sharedPreferencesProvider.overrideWithValue(prefs),
    ],
    child: MaterialApp.router(routerConfig: router),
  ));
}
