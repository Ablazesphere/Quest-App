import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffect extends StatefulWidget {
  final double height;
  final double width;
  final bool rounded;
  const ShimmerEffect(
      {super.key,
      required this.height,
      required this.width,
      required this.rounded});

  @override
  State<ShimmerEffect> createState() => _ShimmerEffectState();
}

class _ShimmerEffectState extends State<ShimmerEffect> {
  @override
  Widget build(BuildContext context) {
    return widget.rounded
        ? Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[400]!,
            child: Container(
              height: widget.height,
              width: widget.width,
              decoration: BoxDecoration(
                color: Colors.white30,
                borderRadius: BorderRadius.circular(5),
              ),
            ))
        : Shimmer.fromColors(
            child: Container(
              height: 300,
              width: 160,
              color: Colors.white30,
            ),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[400]!);
  }
}
