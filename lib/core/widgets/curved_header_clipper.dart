import 'package:flutter/material.dart';

/// Clips a rectangle into the domed/scooped shape used behind the
/// "BiteRush" logo on the Login and Signup screens.
///
/// The top stays a flat rectangle; the bottom edge bulges downward
/// in a smooth arc (like the bottom half of a stretched ellipse).
class CurvedHeaderClipper extends CustomClipper<Path> {
  const CurvedHeaderClipper();

  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.65);

    // Single quadratic bezier: dips down in the middle, meets the
    // same height on both sides — gives the smooth dome/scoop look.
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 1.15,
      size.width,
      size.height * 0.65,
    );

    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
