import 'package:flutter/material.dart';
import 'package:tree_view_flutter/tree_view_flutter.dart';

import 'data/example_tree_type.dart';

class ExStackTreeScreen extends StatefulWidget {
  const ExStackTreeScreen({super.key});

  @override
  State<ExStackTreeScreen> createState() => _ExStackTreeScreenState();
}

class _ExStackTreeScreenState extends State<ExStackTreeScreen> {
  @override
  Widget build(BuildContext context) {
    var listTrees = sampleTreeType();
    
    return Scaffold(
      appBar: AppBar(title: const Text("Example Expandable Tree")),
      body: StackTreeWidget(
        properties: TreeViewProperties(),
        listTrees: listTrees,
      ),
    );
  }
}
