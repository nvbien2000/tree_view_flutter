import 'dart:math';

import 'package:tree_view_flutter/tree_view_flutter.dart';

class CustomNodeType extends AbsNodeType {
  CustomNodeType({
    required dynamic id,
    required dynamic title,
    this.subtitle,
    bool isInner = true,
  }) : super(id: id, title: title, isInner: isInner);

  String? subtitle;

  CustomNodeType.sampleInner(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(inner) title of level $level";
    subtitle = "subtitle of level = $level";
  }

  CustomNodeType.sampleLeaf(String level) : super(id: -1, title: "") {
    super.id = Random().nextInt(100000);
    super.title = "(leaf) title of level $level";
    subtitle = "subtitle of level = $level";
    super.isInner = false;
  }
}
