import 'package:tree_view_flutter/tree_view_flutter.dart';

/// This enum support functions [isChosenAll]
enum EChosenAllValues { chosenAll, unchosenAll, chosenSome, notChosenable }

/// Check if the the tree is chosen all
///
///   - [isThisTreeLazy]: When this function is used in lazy-load tree, some
/// nodes may contain 0 child because they haven't been loaded.
EChosenAllValues isChosenAll<T extends AbsNodeType>(TreeType<T> tree,
    {bool isThisLazyTree = false}) {
  //? Case 1: This tree is only a leaf
  //? ______
  if (tree.isLeaf) {
    if (tree.data.isUnavailable) {
      return EChosenAllValues.notChosenable;
    } else {
      return tree.data.isChosen == true
          ? EChosenAllValues.chosenAll
          : EChosenAllValues.unchosenAll;
    }
  }

  //? Case 2: This tree can contain some children
  //? ______

  /// Means one of it children has been chosen all
  bool hasChosenAll = false;

  /// Means one of it children has been unchosen all
  bool hasUnchosenAll = false;

  /**
   * ! SPECIAL CASE: If tree is loaded lazily -> if its children haven't been
   * ! loaded, do not need to call [isChosenAll(child)] and directly return
   * ! result [isChosen] based on property [tree.isChildrenLoadedLazily]
   * 
   * - If one of its child is [EChosenAllValues.chosenSome], just return & exit.
   * 
   * - Case chosen some: [hasChosenAll && hasUnchosenAll]...
   * 
   * - Case all of children are chosen: [hasChosenAll && !hasUnchosenAll]...
   * 
   * - Case all of children are not chosen: [!hasChosenAll && hasUnchosenAll]...
   * 
   * - Else, return default value [EChosenAllValues.notChosenable]
   */

  // this is lazy tree & its children haven't been loaded
  if (isThisLazyTree && !tree.isChildrenLoadedLazily) {
    if (tree.data.isUnavailable) {
      return EChosenAllValues.notChosenable;
    } else {
      return tree.data.isChosen == true // true
          ? EChosenAllValues.chosenAll
          : EChosenAllValues.unchosenAll; // false (no exist null)
    }
  }

  for (var child in tree.children) {
    var temp = isChosenAll(child, isThisLazyTree: isThisLazyTree);
    switch (temp) {
      case EChosenAllValues.chosenSome:
        return EChosenAllValues.chosenSome;
      case EChosenAllValues.chosenAll:
        hasChosenAll = true;
        break;
      case EChosenAllValues.unchosenAll:
        hasUnchosenAll = true;
        break;
      default:
        break;
    }
  }

  if (hasChosenAll && hasUnchosenAll) {
    return EChosenAllValues.chosenSome;
  } else if (hasChosenAll && !hasUnchosenAll) {
    return EChosenAllValues.chosenAll;
  } else if (!hasChosenAll && hasUnchosenAll) {
    return EChosenAllValues.unchosenAll;
  } else {
    // return default
    return EChosenAllValues.notChosenable;
  }
}

TreeType<T> findRoot<T extends AbsNodeType>(TreeType<T> tree) {
  if (tree.isRoot) return tree;
  return findRoot(tree.parent!);
}

TreeType<T>? findTreeWithId<T extends AbsNodeType>(
    TreeType<T> tree, dynamic id) {
  if (tree.data.id == id) {
    return tree;
  } else {
    for (var innerTree in tree.children) {
      TreeType<T>? recursionResult = findTreeWithId(innerTree, id);
      if (recursionResult != null) return recursionResult;
    }
  }
  return null;
}

/// Using DFS to return all the trees if each of root's data contains searching
/// text
void searchAllTreesWithTitleDFS<T extends AbsNodeType>(
    TreeType<T> tree, String text, List<TreeType<T>> result) {
  if (tree.data.isUnavailable) return;

  if (tree.data.title.contains(text)) result.add(tree);

  for (var child in tree.children) {
    searchAllTreesWithTitleDFS(child, text, result);
  }
}

/// Using DFS to return leaves if each of leaf's data contains searching text
void searchLeavesWithTitleDFS<T extends AbsNodeType>(
    TreeType<T> tree, String text, List<TreeType<T>> result) {
  if (tree.data.isUnavailable) return;

  if (tree.isLeaf && tree.data.title.contains(text)) {
    result.add(tree);
    return;
  }

  for (var child in tree.children) {
    searchAllTreesWithTitleDFS(child, text, result);
  }
}

void returnChosenLeaves<T extends AbsNodeType>(
    TreeType<T> tree, List<TreeType<T>> result) {
  if (tree.data.isUnavailable) return;

  if (tree.isLeaf && tree.data.isChosen == true) {
    result.add(tree);
    return;
  }

  for (var child in tree.children) {
    returnChosenLeaves(child, result);
  }
}

void returnChosenNodes<T extends AbsNodeType>(
    TreeType<T> tree, List<TreeType<T>> result) {
  if (tree.data.isUnavailable) return;

  if (tree.data.isChosen == true) result.add(tree);

  for (var child in tree.children) {
    returnChosenNodes(child, result);
  }
}
