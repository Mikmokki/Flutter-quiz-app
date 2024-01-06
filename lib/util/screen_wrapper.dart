import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScreenWrapper extends StatelessWidget {
  final Widget widget;
  const ScreenWrapper(this.widget, {super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        leadingWidth: 150,
        title: const Center(child: Text("Super Quiz App")),
        leading: IconButton(
          onPressed: () => context.go("/"),
          tooltip: "Topics",
          icon: const Row(
            children: [
              Icon(Icons.home),
              SizedBox(width: 5.0),
              Text("Topics",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => context.go("/statistics"),
            tooltip: "Statistics",
            icon: const Row(
              children: [
                Text("Statistics",
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    )),
                SizedBox(width: 5.0),
                Icon(Icons.bar_chart),
              ],
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: widget,
      ),
    ));
  }
}
