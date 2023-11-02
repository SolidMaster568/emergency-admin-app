import 'package:emg/utils/colors.dart';
import 'package:flutter/material.dart';

class ProfileImageWidget extends StatelessWidget {
  const ProfileImageWidget({super.key, this.height, this.width});

  final double? width, height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? 60,
      height: height ?? 60,
      decoration: BoxDecoration(
        color: colorSnow,
        borderRadius: width != null
            ? BorderRadius.circular(8)
            : BorderRadius.circular(12),
      ),
      child: Icon(
        Icons.person,
        color: colorWhite,
        size: width ?? 50,
      ),
    );
  }
}
