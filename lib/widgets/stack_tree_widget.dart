import 'package:flutter/material.dart';
import 'package:tree_view_flutter/tree_view_flutter.dart';

/// **Note 1**: When access this sheet for the first time,
/// it could open a child, not root of the tree. Therefore we need
/// a variable to know where is its parent.
///
/// **Note 2**: WHEN there is only 1 entire a tree: `listTrees = [root]`.
///
/// **Note 3**: Entire data is parsed only 1 time.
///
/// **Note 4**: Specify tree view widget's height
class StackTreeWidget<T extends AbsNodeType> extends StatefulWidget {
  const StackTreeWidget({
    super.key,
    required this.properties,
    required this.fetchDataFunction,
  });

  final TreeViewProperties properties;
  final Future<List<TreeType<T>>> fetchDataFunction;

  @override
  State<StackTreeWidget> createState() => _StackTreeWidgetState<T>();
}

class _StackTreeWidgetState<T extends AbsNodeType>
    extends State<StackTreeWidget<T>> {
  List<TreeType<T>> listTrees = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<TreeType<T>>>(
      future: widget.fetchDataFunction,
      builder: (_, snapshot) {
        if (snapshot.hasData) {
          listTrees = snapshot.data ?? [];
          if (listTrees.isEmpty) {
            return widget.properties.emptyWidget;
          } else {
            return _buildTreeView();
          }
        } else if (snapshot.hasError) {
          return DefaultErrorWidget(snapshot.error.toString());
        }

        return widget.properties.loadingWidget;
      },
    );
  }

  Widget _buildTreeView() {
    if (listTrees[0].parent == null) {
      return _buildRootsOfTrees();
    } else {
      return _buildChildrenOfTrees();
    }
  }

  Widget _buildRootsOfTrees() {
    return Column(
      children: [
        //? top title
        ListTile(
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          leading: const SizedBox(),
          title: Text(
            widget.properties.title,
            textAlign: TextAlign.center,
            style: widget.properties.titleStyle,
          ),
        ),
        const SizedBox(height: 10),

        //? main view, including 1 root
        Expanded(
          child: ListView.separated(
            itemCount: listTrees.length,
            itemBuilder: (_, int index) {
              if (listTrees[index].isLeaf) {
                return _buildLeafNodeWidget(listTrees[index]);
              } else {
                return _buildInnerNodeWidget(listTrees[index]);
              }
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ],
    );
  }

  Widget _buildChildrenOfTrees() {
    return Column(
      children: [
        //? top title is current tree's parent title
        ListTile(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              setState(() {
                var parentOfCurrentTrees = listTrees[0].parent!;
                // is this parent already root?
                if (parentOfCurrentTrees.isRoot) {
                  listTrees = [parentOfCurrentTrees];
                } else {
                  var parentOfParentOfCurrentTree =
                      parentOfCurrentTrees.parent!;
                  listTrees = parentOfParentOfCurrentTree.children;
                }
              });
            },
          ),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            listTrees[0].parent!.data.title,
            style: widget.properties.titleStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10),

        //? main view
        Expanded(
          child: ListView.separated(
            itemCount: listTrees.length,
            itemBuilder: (BuildContext context, int index) {
              var currentTree = listTrees[index];

              if (currentTree.data.isInner) {
                return _buildInnerNodeWidget(currentTree);
              } else {
                return _buildLeafNodeWidget(listTrees[index]);
              }
            },
            separatorBuilder: (_, __) => const Divider(),
          ),
        ),
      ],
    );
  }

  Widget _buildLeafNodeWidget(TreeType<T> leafTree) {
    return ListTile(
      onTap: () {},
      title: Text(
        leafTree.data.title,
        style: widget.properties.listTileTitleStyle,
      ),
      leading: widget.properties.leafLeadingWidget,
      trailing: Checkbox(
        tristate: true,
        side: leafTree.data.isUnavailable
            ? const BorderSide(color: Colors.grey, width: 1.0)
            : BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        value: leafTree.data.isChosen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        //! leaf [isChosen] is always true or false, cannot be null
        onChanged: leafTree.data.isUnavailable
            ? null
            : (_) => setState(
                // leaf always has bool value (not null).
                () => updateTreeMultipleChoice(
                      leafTree,
                      !leafTree.data.isChosen!,
                    )),
      ),
    );
  }

  _buildInnerNodeWidget(TreeType<T> innerNode) {
    return ListTile(
      onTap: () {
        if (innerNode.children.isEmpty) return;
        setState(() => listTrees = innerNode.children);
      },
      tileColor: null,
      title: Text(
        '${innerNode.data.title} (${innerNode.children.length})',
        style: widget.properties.listTileTitleStyle,
      ),
      leading: widget.properties.innerNodeLeadingWidget,
      trailing: Checkbox(
        tristate: true,
        side: innerNode.data.isUnavailable
            ? const BorderSide(color: Colors.grey, width: 1.0)
            : BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        value: innerNode.data.isUnavailable ? false : innerNode.data.isChosen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        activeColor: innerNode.data.isUnavailable
            ? Colors.grey
            : Theme.of(context).primaryColor,
        onChanged: innerNode.data.isUnavailable
            ? null
            : (value) => setState(() => updateTreeMultipleChoice(
                  innerNode,
                  value,
                )),
      ),
    );
  }
}
