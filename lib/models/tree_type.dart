import 'package:tree_view_flutter/tree_view_flutter.dart';

class TreeType<T extends AbsNodeType> {
  TreeType({
    required this.data,
    required this.children,
    required this.parent,
    this.isChildrenLoadedLazily = false,
  });

  T data;
  List<TreeType<T>> children;

  /// If `parent == null`, it is root of the tree.
  TreeType<T>? parent;

  /// This property is used to know if the children were **LAZILY** loaded or 
  /// not - useful ONLY in **Lazy Tree View**. Default value is [false].
  bool isChildrenLoadedLazily;

  bool get isLeaf => !data.isInner;
  bool get isRoot => parent == null;
}
