import 'package:tree_view_flutter/tree_view_flutter.dart';

import 'custom_node_type.dart';

List<TreeType<CustomNodeType>> sampleTreeType<T extends AbsNodeType>() {
  var root =  TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInner("0"),
    children: [],
    parent: null,
  );

  // ------------------ lv 1

  var lv1_1 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInner("1.1"),
    children: [],
    parent: root,
  );

  var lv1_2 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInner("1.2"),
    children: [],
    parent: root,
  );

  // ------------------ lv 2

  var lv2_1 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInner("2.1"),
    children: [],
    parent: lv1_1,
  );

  var lv2_2 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInner("2.2"),
    children: [],
    parent: lv1_1,
  );

  var lv2_3 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleInner("2.3"),
    children: [],
    parent: lv1_1,
  );

  // ------------------ lv 2

  var lv3_1 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeaf("3.1"),
    children: [],
    parent: lv2_1,
  );

  var lv3_2 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeaf("3.2"),
    children: [],
    parent: lv2_1,
  );

  var lv3_3 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeaf("3.3"),
    children: [],
    parent: lv2_1,
  );

  var lv3_4 = TreeType<CustomNodeType>(
    data: CustomNodeType.sampleLeaf("3.4"),
    children: [],
    parent: lv2_2,
  );

  // --- connect everything together

  root.children.addAll([lv1_1, lv1_2]);
  lv1_1.children.addAll([lv2_1, lv2_2, lv2_3]);
  lv2_1.children.addAll([lv3_1, lv3_2, lv3_3]);
  lv2_2.children.addAll([lv3_4]);

  updateAllUnavailableNodes(root);

  return [lv1_1, lv1_2];
}
