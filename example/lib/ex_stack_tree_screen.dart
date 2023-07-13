import 'package:example/data/custom_node_type.dart';
import 'package:flutter/material.dart';
import 'package:tree_view_flutter/tree_view_flutter.dart';

import 'data/example_tree_type_1.dart';

/// data was parsed 1 time
class ExStackTreeScreen extends StatefulWidget {
  const ExStackTreeScreen({super.key});

  @override
  State<ExStackTreeScreen> createState() => _ExStackTreeScreenState();
}

class _ExStackTreeScreenState extends State<ExStackTreeScreen> {
  List<TreeType<CustomNodeType>> listTrees = [];
  final String searchingText = "3";

  @override
  void initState() {
    listTrees = sampleTree();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stack Tree (multiple choice)")),
      body: Column(
        children: [
          const SizedBox(height: 30),
          const Text(
            "Stack tree widget was built for fun :)",
            style: TextStyle(color: Colors.red),
          ),
          const Divider(
            thickness: 2,
            height: 60,
          ),
          Expanded(
            child: StackTreeWidget(
              properties: TreeViewProperties<CustomNodeType>(
                title: "THIS IS TITLE",
              ),
              listTrees: listTrees,
            ),
          ),
          const Divider(
            thickness: 2,
            height: 60,
          ),
          OutlinedButton(
            onPressed: () {
              List<TreeType<CustomNodeType>> result = [];
              var root = findRoot(listTrees[0]);
              returnChosenLeaves(root, result);
              String resultTxt = "";
              for (var e in result) {
                resultTxt += "${e.data.title}\n";
              }
              if (resultTxt.isEmpty) resultTxt = "none";

              var snackBar = SnackBar(content: Text(resultTxt));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: const Text("Which leaves were chosen?"),
          ),
          OutlinedButton(
            onPressed: () {
              List<TreeType<CustomNodeType>> result = [];
              var root = listTrees[0].parent!;
              searchAllTreesWithTitleDFS(root, searchingText, result);
              String resultTxt = "";
              for (var e in result) {
                resultTxt += "${e.data.title}\n";
              }
              if (resultTxt.isEmpty) resultTxt = "none";

              var snackBar = SnackBar(content: Text(resultTxt));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            child: Text("Which nodes contain text='$searchingText'?"),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
