import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart'; // Import the shimmer package

class ShimmerMessages extends StatelessWidget {
  const ShimmerMessages({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Align(
        alignment: index % 2 == 0 ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.5),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Color(0xff467271),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Shimmer.fromColors(
            baseColor: Color(0xff467271),
            highlightColor: Colors.white,
            child: Container(
              width: 100,
              height: 15,
              color: Color(0xff467271),
            ),
          ),
        ),
      ),
    );
  }
}
