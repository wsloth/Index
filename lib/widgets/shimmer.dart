import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final double marginBottom;
  final Alignment alignment;

  /// Renders a shimmering line that can be used to represent loading
  /// text. The width is 100% by default, but can be fixed.
  const ShimmerText({
    Key key,
    this.width = double.infinity,
    this.height = 16,
    this.marginBottom = 0,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Align(alignment: alignment, child: Shimmer.fromColors(
        baseColor: Colors.grey[300],
        highlightColor: Colors.grey[100],
        child: Container(
          width: width,
          height: height,
          color: Colors.white,
        ),
      )),
      SizedBox(height: marginBottom),
    ]);
  }
}

class ShimmerArticle extends StatelessWidget {
  const ShimmerArticle({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const ShimmerText(height: 18),
      SizedBox(height: 8),
      const ShimmerText(height: 18, width: 225),
      SizedBox(height: 24),
    ]);
  }
}
