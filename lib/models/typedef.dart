import 'package:tree_view_flutter/tree_view_flutter.dart';

typedef FunctionGetTreeChildren<T extends AbsNodeType> = List<TreeType<T>>
    Function(TreeType<T> parent);