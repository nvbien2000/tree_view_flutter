import 'package:flutter/material.dart';
import 'package:tree_view_flutter/tree_view_flutter.dart';

import 'data/example_tree_type.dart';

class ExExpandableTreeScreen extends StatefulWidget {
  const ExExpandableTreeScreen({super.key});

  @override
  State<ExExpandableTreeScreen> createState() => _ExExpandableTreeScreenState();
}

class _ExExpandableTreeScreenState extends State<ExExpandableTreeScreen> {
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
