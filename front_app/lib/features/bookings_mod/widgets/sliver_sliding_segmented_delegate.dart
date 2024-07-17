import 'package:flutter/material.dart';

class SliverSlidingSegmentedDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  SliverSlidingSegmentedDelegate(this.child, [this.height = 100]);

  @override
  Widget build(context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => height;

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
