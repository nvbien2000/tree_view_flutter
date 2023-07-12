import 'package:flutter/material.dart';

import 'ex_stack_tree_screen.dart';
import 'ex_lazy_stack_tree_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tree View Flutter Example")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildButton(
              context,
              const ExStackTreeScreen(),
              "Stack Tree\nmultiple choice - parse data 1 time",
            ),
            _buildButton(
              context,
              const ExLazyStackTreeScreen(),
              "Lazy Stack Tree\nmultiple choice - parse data run-time",
            ),
            // _buildButton(
            //   context,
            //   const ExStackTreeScreen(),
            //   "Stack Tree\nsingle choice - parse data 1 time",
            // ),
            //_____________________
            const Divider(
              thickness: 2,
              height: 50,
              color: Colors.black,
            ),
            //_____________________
            _buildButton(
              context,
              const ExStackTreeScreen(),
              "Expandable Tree\nmultiple choice - parse data 1 time",
            ),
            _buildButton(
              context,
              const ExLazyStackTreeScreen(),
              "Lazy Expandable Tree\nmultiple choice - parse data run-time",
            ),
            // _buildButton(
            //   context,
            //   const ExStackTreeScreen(),
            //   "Expandable Tree\nsingle choice - parse data 1 time",
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
          BuildContext context, StatefulWidget screen, String title) =>
      OutlinedButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => screen),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
        ),
      );
}
