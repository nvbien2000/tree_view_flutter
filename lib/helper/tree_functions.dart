import '../data_structure/abstract_node_type.dart';
import '../data_structure/tree_type.dart';

/// **This function is used to update all unavailable nodes of current tree**.
///
/// Function returns a boolean, [true] if current tree is chosenable,
/// else [false].
///
/// When we first time parse data (json, map, list, etc) to tree data structure,
/// there could be some nodes are unavailable `but` haven't been updated yet.
///
/// Example: Client wants to choose few employees (which represent leaves)
/// in a department (which represent inner nodes). If department `A` doesn't
/// have any available employee, it will be also marked as `unavailable`.
///
/// It is **NECESSARY** to call this function at the first time the tree
/// initialized.
bool updateAllUnavailableNodes<T extends AbsNodeType>(TreeType<T> tree) {
  if (tree.isLeaf) return !tree.data.isUnavailable;

  bool isThisTreeAvailable = false;
  for (var child in tree.children) {
    if (updateAllUnavailableNodes(child)) isThisTreeAvailable = true;
  }

  if (isThisTreeAvailable) {
    return true;
  } else {
    tree.data.isUnavailable = true;
    return false;
  }
}

/// This enum support functions [isChosenAll]
enum EChosenAllValues { chosenAll, unchosenAll, chosenSome, notChosenable }

/// Check if the the tree is chosen all
EChosenAllValues isChosenAll<T extends AbsNodeType>(TreeType<T> tree) {
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

  for (var child in tree.children) {
    var temp = isChosenAll(child);
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

/// [checkAll] for this tree (from current node to bottom)
bool checkAll<T extends AbsNodeType>(TreeType<T> tree) {
  tree.data.isChosen = true;

  // need to use index, if not, it could create another instance of [TreeType]
  for (int i = 0; i < tree.children.length; i++) {
    checkAll(tree.children[i]);
  }

  return true;
}

/// [uncheckAll] for this tree (from current node to bottom)
bool uncheckALl<T extends AbsNodeType>(TreeType<T> tree) {
  tree.data.isChosen = false;

  // need to use index, if not, it could create another instance of [TreeType]
  for (int i = 0; i < tree.children.length; i++) {
    uncheckALl(tree.children[i]);
  }

  return true;
}

/// [updateTreeMultipleChoice] when choose/un-choose a node:
///
/// - [chosenValue]: same meaning as [isChosen] in [AbsNodeType].
/// - [isUpdatingParentRecursion]: is used to determine whether we are updating
/// the parent/ancestors tree or updating the children of this tree.
bool updateTreeMultipleChoice<T extends AbsNodeType>(
    TreeType<T> tree, bool? chosenValue,
    {bool isUpdatingParentRecursion = false}) {
  // Step 1. update current node
  tree.data.isChosen = chosenValue;

  // Step 2. update its children
  if (!tree.isLeaf && !isUpdatingParentRecursion) {
    /// if not [isUpdatingParentRecursion], means this is the first time call
    /// function [updateTree], [chosenValue] is not nullable for now
    if (chosenValue == true) {
      checkAll(tree);
    } else {
      uncheckALl(tree);
    }
  }

  // Step 3. update parent
  if (!tree.isRoot) {
    var parent = tree.parent!;
    var parentChosenValue = isChosenAll(parent);

    switch (parentChosenValue) {
      case EChosenAllValues.chosenSome:
        updateTreeMultipleChoice(parent, null, isUpdatingParentRecursion: true);
        break;
      case EChosenAllValues.chosenAll:
        updateTreeMultipleChoice(parent, true, isUpdatingParentRecursion: true);
        break;
      case EChosenAllValues.unchosenAll:
        updateTreeMultipleChoice(parent, false,
            isUpdatingParentRecursion: true);
        break;
      default:
        throw Exception(
            "File: tree_function.dart\nFunction: updateTree()\nException: EChosenAllValues.notChosenable\nMessage: Some logic error happen");
    }
  }

  return true;
}

/// The tree is single choice, not multiple choice. Only leaf can be chosen.
bool updateTreeSingleChoice<T extends AbsNodeType>(
    TreeType<T> tree, bool chosenValue) {
  /// if `chosenValue == true`, all of its ancestors ancestors must have value
  /// `isChosen == null` (because we need to customize UI of each inner node if
  /// one of its children is chosen), others have value `false`.
  ///
  /// Otherwise, just update everything - every nodes value to `false`.

  // uncheck all
  var root = findRoot(tree);
  uncheckALl(root);

  // if chosen value is true, update all of its ancestors value to null
  if (chosenValue) {
    updateAncestorsToNull(tree);
  } else {}

  // update current node value
  tree.data.isChosen = chosenValue;

  return true;
}

TreeType<T> findRoot<T extends AbsNodeType>(TreeType<T> tree) {
  if (tree.isRoot) return tree;
  return findRoot(tree.parent!);
}

bool updateAncestorsToNull<T extends AbsNodeType>(TreeType<T> tree) {
  tree.data.isChosen = null;
  if (tree.isRoot) return true;
  return updateAncestorsToNull(tree.parent!);
}

// /// This function help find **A TREE**, which contains its whole children
// TreeType<T>? findTreeWithId<T extends AbsNodeType>(
//     TreeType<T> tree, dynamic id) {
//   if (tree.data.id == id) {
//     return tree;
//   } else {
//     for (var innerTree in tree.childrenNodes) {
//       TreeType<T>? recursionResult = findTreeWithId(innerTree, id);
//       if (recursionResult != null) return recursionResult;
//     }
//   }
//   return null;
// }

// /// This function help find **A NODE**
// /// (only a node, not contains its whole children)
// T? findNodeWithId<T extends AbsNodeType>(TreeType<T> tree, dynamic id) {
//   if (tree.data.id == id) {
//     return tree.data;
//   } else {
//     for (var innerNode in tree.childrenNodes) {
//       T? recursionResult = findNodeWithId(innerNode, id);
//       if (recursionResult != null) return recursionResult;
//     }
//   }
//   return null;
// }

// /// Is there any leaf on this tree is available for choosing?
// bool isTreeChosenable<T extends AbsNodeType>(TreeType<T> tree) {
//   print("[isTreeChosenable] ${tree.data.title}");
//   if (tree.isLeaf) return !tree.data.isDisabled;

//   // if one of it children is chosenable, then tree is chosenable
//   for (var child in tree.childrenNodes) {
//     if (isTreeChosenable(child)) return true;
//   }

//   return false;
// }
