import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerText extends StatelessWidget {
  final double width;
  final double height;
  final double marginBottom;
  final Alignment alignment;

  /// Renders a shimmering line that can be used to represent loading
  /// text. The width is 100% by default, but can be fixed.
  const ShimmerText({
    Key? key,
    this.width = double.infinity,
    this.height = 16,
    this.marginBottom = 0,
    this.alignment = Alignment.centerLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? shimmerBase = Get.isDarkMode ? Colors.grey[850] : Colors.grey[300];
    Color? shimmerHighlight =
        Get.isDarkMode ? Colors.grey[700] : Colors.grey[100];
    return Column(children: [
      Align(
          alignment: alignment,
          child: Shimmer.fromColors(
            baseColor: shimmerBase!,
            highlightColor: shimmerHighlight!,
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
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ShimmerText(height: 18),
      SizedBox(height: 8),
      ShimmerText(height: 18, width: 225),
      SizedBox(height: 24),
    ]);
  }
}
