import 'package:flutter/material.dart';

class ExExpandableTreeScreen extends StatefulWidget {
  const ExExpandableTreeScreen({super.key});

  @override
  State<ExExpandableTreeScreen> createState() => _ExExpandableTreeScreenState();
}

class _ExExpandableTreeScreenState extends State<ExExpandableTreeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Example Expandable Tree")),
      body: Container(),
    );
  }
}
