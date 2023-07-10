import 'package:flutter/material.dart';

class ExStackTreeScreen extends StatefulWidget {
  const ExStackTreeScreen({super.key});

  @override
  State<ExStackTreeScreen> createState() => _ExStackTreeScreenState();
}

class _ExStackTreeScreenState extends State<ExStackTreeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Example Stack Tree")),
      body: Container(),
    );
  }
}
