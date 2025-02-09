import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomLoginOptions extends StatelessWidget {
  const CustomLoginOptions({super.key, required this.onPressed, required this.text, required this.imagePath});
  final void Function()? onPressed;
  final String text;
  final String imagePath;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            color: Colors.black12,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onPressed,
      icon: SvgPicture.asset(
            imagePath,
            width: 35,
          ),
    );
  }
}
