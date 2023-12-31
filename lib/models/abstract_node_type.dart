/// An abstract class about node data type. There're 2 kinds of node:
/// inner node (including root) & leaf node.
abstract class AbsNodeType {
  dynamic id;
  String title;

  /// Default value is `true`.
  bool isInner;

  /// A node is disabled/unavailable for some reasons? --\\_(^.^)_/--
  ///
  /// Default value is `false`.
  bool isUnavailable;

  /// - Inner node:
  ///   + If `isChosen == true`, all of its children are chosen.
  ///   + if `isChosen == false`, all of its children are unchosen.
  ///   + If `isChosen == null`, some of its children are chosen, some are not.
  /// - Leaf node: Only `true` or `false`.
  ///
  /// The default value is false (unchosen-all)
  bool? isChosen;

  AbsNodeType({
    required this.id,
    required this.title,
    this.isInner = true,
    this.isUnavailable = false,
    this.isChosen = false,
  }) {
    if (!isInner && isChosen == null) {
      throw ArgumentError("Leaf node's `isChosen` cannot contain null value.");
    }
  }
}
