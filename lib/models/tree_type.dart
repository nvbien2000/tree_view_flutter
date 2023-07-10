import 'package:tree_view_flutter/tree_view_flutter.dart';

class TreeType<T extends AbsNodeType> {
  TreeType({
    required this.data,
    required this.children,
    required this.parent,
  });

  T data;
  List<TreeType<T>> children;

  /// If `parent == null`, it is root of the tree
  TreeType<T>? parent;

  bool get isLeaf => !data.isInner;
  bool get isRoot => parent == null;
}
